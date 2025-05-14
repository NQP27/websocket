import logging
import psycopg2
import json
import threading
import time
from datetime import datetime
from binance.websocket.spot.websocket_stream import SpotWebsocketStreamClient
import signal

# Thiết lập log
logging.basicConfig(level=logging.INFO)

# === Thông tin TimescaleDB ===
DB_CONFIG = {
    "host": "localhost",
    "port": 5433,
    "dbname": "postgres",
    "user": "postgres",
    "password": "admin"
}

# === Cờ để kiểm soát dừng toàn cục ===
stop_event = threading.Event()

# === Hàm xử lý dữ liệu order book ===
def handle_order_book(_, message, conn, cur):
    try:
        if isinstance(message, str):
            message = json.loads(message)
        if message.get("e") != "depthUpdate":
            return

        symbol = message["s"]
        event_time = datetime.utcfromtimestamp(message["E"] / 1000.0)

        for side, data in [("bid", message.get("b", [])), ("ask", message.get("a", []))]:
            for price_str, qty_str in data:
                price = float(price_str)
                quantity = float(qty_str)

                if quantity == 0:
                    cur.execute("""
                        DELETE FROM dwh.order_book
                        WHERE symbol = %s AND event_time = %s AND side = %s AND price = %s;
                    """, (symbol, event_time, side, price))
                else:
                    cur.execute("""
                        INSERT INTO dwh.order_book (symbol, event_time, side, price, quantity)
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT (symbol, event_time, side, price)
                        DO UPDATE SET quantity = EXCLUDED.quantity;
                    """, (symbol, event_time, side, price, quantity))

        conn.commit()
        print(f"✅ [{symbol}] Order book updated at {event_time}")

    except Exception as e:
        print(f"❌ Order book error: {e}")
        conn.rollback()

# === Hàm chạy 1 nhóm symbol trong 1 thread ===
def run_symbols_group(symbols):
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    def on_message(_, msg):
        handle_order_book(_, msg, conn, cur)

    ws_client = SpotWebsocketStreamClient(on_message=on_message)

    for symbol in symbols:
        stream = f"{symbol.lower()}@depth@100ms"
        ws_client.subscribe(stream=stream)
    print(f"🧵 Thread started for: {symbols}")

    try:
        while not stop_event.is_set():
            time.sleep(1)
    finally:
        ws_client.stop()
        cur.close()
        conn.close()
        print(f"🔴 Thread stopped for: {symbols}")

# === Hàm xử lý Ctrl + C ===
def signal_handler(sig, frame):
    print("\n🛑 Ctrl+C received! Stopping all threads...")
    stop_event.set()

signal.signal(signal.SIGINT, signal_handler)

# === Main ===
if __name__ == "__main__":
    with open("./files/crypto_symbols.json", "r") as f:
        all_symbols = json.load(f)["symbols"]

    def chunk_list(lst, n):
        for i in range(0, len(lst), n):
            yield lst[i:i + n]

    threads = []
    for group in chunk_list(all_symbols, 5):
        t = threading.Thread(target=run_symbols_group, args=(group,))
        t.start()
        threads.append(t)

    for t in threads:
        t.join()

    print("✅ All threads stopped. Bye.")
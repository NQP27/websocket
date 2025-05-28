import logging
import psycopg2
import json
import threading
import time
from datetime import datetime
from binance.websocket.spot.websocket_stream import SpotWebsocketStreamClient
import signal


RECONNECT_INTERVAL = 3000 # Thời gian kết nối lại (giây)


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

    print(f"🧵 Thread started for: {symbols}")

    ws_client = None
    last_reconnect_time = 0

    try:
        while not stop_event.is_set():
            current_time = time.time()
            if ws_client is None or current_time - last_reconnect_time >= RECONNECT_INTERVAL:
                # Reconnect WebSocket sau mỗi 1 tiếng
                if ws_client is not None:
                    print(f"🔄 Reconnecting WebSocket for: {symbols}")
                    ws_client.stop()
                    time.sleep(1)  # nghỉ 1 chút để đảm bảo ngắt kết nối xong

                ws_client = SpotWebsocketStreamClient(on_message=on_message)

                for symbol in symbols:
                    stream = f"{symbol.lower()}@depth@100ms"
                    ws_client.subscribe(stream=stream)

                last_reconnect_time = current_time
                print(f"✅ WebSocket connected for: {symbols}")

            time.sleep(1)

    finally:
        if ws_client is not None:
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

    # Chờ tất cả thread kết thúc
    for t in threads:
        t.join()

    print("✅ All threads stopped. Bye.")

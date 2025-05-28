import logging
import psycopg2
import json
import threading
import time
from datetime import datetime
from binance.websocket.spot.websocket_stream import SpotWebsocketStreamClient
import signal
import sys


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

# === Hàm xử lý tick từ Binance WebSocket ===
def handle_trade(_, message, conn, cur):
    try:
        if isinstance(message, str):
            message = json.loads(message)
        if message.get("e") != "trade":
            return

        trade_id = int(message["t"])
        event_time = datetime.utcfromtimestamp(message["E"] / 1000.0)
        trade_time = datetime.utcfromtimestamp(message["T"] / 1000.0)
        symbol = message["s"]
        price = float(message["p"])
        quantity = float(message["q"])
        is_buyer_maker = message["m"]

        cur.execute("""
            INSERT INTO dwh."tick_data" (trade_id, event_time, symbol, price, quantity, is_buyer_maker, trade_time)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (trade_id, event_time) DO NOTHING;
        """, (trade_id, event_time, symbol, price, quantity, is_buyer_maker, trade_time))

        conn.commit()
        print(f"✅ [{symbol}] Saved: {price}@{quantity} at {event_time}")

    except Exception as e:
        print(f"❌ [{symbol}] Error: {e}")
        conn.rollback()

# === Hàm chạy 1 nhóm symbol trong 1 thread ===
def run_symbols_group(symbols):
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    def on_message(_, msg):
        handle_trade(_, msg, conn, cur)

    ws_client = None
    last_reconnect_time = 0

    print(f"🧵 Thread started for: {symbols}")

    try:
        while not stop_event.is_set():
            current_time = time.time()
            if ws_client is None or current_time - last_reconnect_time >= RECONNECT_INTERVAL:
                if ws_client is not None:
                    logging.info(f"🔄 Reconnecting WebSocket for: {symbols}")
                    ws_client.stop()
                    time.sleep(1)  # Chờ nhẹ để đảm bảo kết nối cũ dừng hẳn

                ws_client = SpotWebsocketStreamClient(on_message=on_message)

                for symbol in symbols:
                    ws_client.trade(symbol=symbol.lower())

                last_reconnect_time = current_time
                logging.info(f"✅ WebSocket connected for: {symbols}")

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

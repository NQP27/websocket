import json
import random
import string
import datetime
import re
import pandas as pd
import sys
import time
from pathlib import Path
from constants.enum import TimeframesTv, Tables
from websocket import create_connection
from concurrent.futures import ThreadPoolExecutor, as_completed
import psycopg2
from psycopg2.extras import execute_values

DB_CONFIG = {
    "host": "localhost",
    "port": 5433,
    "dbname": "postgres",
    "user": "postgres",
    "password": "admin",
}


def insert_to_db(df: pd.DataFrame, table_name: str):
    df = df.reset_index() 
    if df.empty:
        print(f"⚠️ DataFrame rỗng, bỏ qua insert vào bảng {table_name}")
        return

    try:
        with psycopg2.connect(**DB_CONFIG) as conn:
            with conn.cursor() as cur:
                columns = [
                    "symbol", "prename", "broker", "data_source",
                    "open", "close", "high", "low", "co", "hl",
                    "tick_vol", "datetime", "direction"
                ]
                values = [tuple(row[col] for col in columns) for _, row in df.iterrows()]
                query = f"INSERT INTO {table_name} ({','.join(columns)}) VALUES %s"
                execute_values(cur, query, values)
                conn.commit()
                print(f"✅ Đã insert {len(df)} dòng vào bảng {table_name}")
    except Exception as e:
        print(f"❌ Lỗi khi insert dữ liệu vào DB: {e}")


def get_table_from_timeframe(tf_str: str, env="staging"):
    try:
        tf_enum = next(tf for tf in TimeframesTv if tf.value == tf_str)
        table_name = Tables[tf_enum.name].value
        return f"{env}.{table_name}"
    except (StopIteration, KeyError) as e:
        raise ValueError(f"❌ Không tìm thấy bảng tương ứng với timeframe '{tf_str}'") from e


def gen_session(prefix="cs"):
    return f"{prefix}_{''.join(random.choices(string.ascii_lowercase, k=12))}"


def prepend_header(msg):
    return f"~m~{len(msg)}~m~{msg}"


def create_message(method, params):
    return json.dumps({"m": method, "p": params}, separators=(",", ":"))


def parse_series(raw_data, symbol, prename, broker, data_source="tradingview"):
    try:
        match = re.search('"s":\[(.+?)\}\]', raw_data)
        if not match:
            raise ValueError("Không tìm thấy chuỗi dữ liệu trong raw_data")
        data_raw = match.group(1).split(',{"')

        data = []
        for item in data_raw:
            parts = re.split(r"\[|:|,|\]", item)
            ts = datetime.datetime.fromtimestamp(float(parts[4]))
            o, h, l, c, v = map(float, parts[5:10])
            co = round(c - o, 5)
            hl = round(h - l, 5)
            direction = "up" if co > 0 else "down" if co < 0 else "keep"

            row = [
                symbol, prename, broker, data_source,
                o, c, h, l, co, hl, v, ts, direction
            ]
            data.append(row)

        return pd.DataFrame(data, columns=[
            "symbol", "prename", "broker", "data_source",
            "open", "close", "high", "low", "co", "hl",
            "tick_vol", "datetime", "direction"
        ])
    except Exception as e:
        print(f"❌ Lỗi parse dữ liệu {symbol}: {e}")
        return pd.DataFrame()


def process_batch(assets, source, timeframe, n_bars, token, max_retries=4):
    for attempt in range(1, max_retries + 1):
        try:
            print(f"🚀 Xử lý batch {assets} (Thử lần {attempt}/{max_retries})")
            time.sleep(random.uniform(1, 10))
            ws = create_connection("wss://data.tradingview.com/socket.io/websocket", timeout=10)

            def send(method, params):
                msg = prepend_header(create_message(method, params))
                ws.send(msg)

            send("set_auth_token", [token])
            quote_session = gen_session("qs")
            send("quote_create_session", [quote_session])
            for symbol, prename in assets:
                send("quote_add_symbols", [quote_session, f"{source}:{prename}", {"flags": ["force_permission"]}])

            raw_data = {prename: "" for _, prename in assets}
            completed = set()

            for i, (symbol, prename) in enumerate(assets):
                chart_session = gen_session("cs")
                sym_id = f"symbol_{i}"
                series_id = f"s{i}"
                send("chart_create_session", [chart_session, ""])
                send("resolve_symbol", [
                    chart_session, sym_id,
                    f'={{"symbol":"{source}:{prename}","adjustment":"splits","session":"regular"}}'
                ])
                send("create_series", [chart_session, series_id, series_id, sym_id, timeframe, n_bars])

            while len(completed) < len(assets):
                try:
                    res = ws.recv()
                    for i, (_, prename) in enumerate(assets):
                        if f'"s{i}"' in res:
                            raw_data[prename] += res + "\n"
                            if "series_completed" in res:
                                completed.add(prename)
                except Exception as e:
                    print(f"⚠️ WebSocket error khi nhận dữ liệu: {e}")
                    ws.close()
                    raise

            ws.close()

            all_df = []
            for symbol, prename in assets:
                df = parse_series(raw_data[prename], symbol, prename, source)
                if not df.empty:
                    all_df.append(df)

            return pd.concat(all_df) if all_df else pd.DataFrame()

        except Exception as e:
            print(f"❌ Lỗi trong batch (attempt {attempt}): {e}")
            time.sleep(2)  # Tạm dừng trước khi retry

    print("❌ Vượt quá số lần retry, bỏ batch.")
    return pd.DataFrame()


def main():
    with open("./files/forex_key.json", "r") as f:
        token = json.load(f)["tradingview"]["sen07"]["token"]

    with open("./files/assets.json", "r") as f:
        assets = list(json.load(f)["symbols"]["oanda"].items())[:12]

    timeframe = sys.argv[1] if len(sys.argv) > 1 else "1D"
    n_bars = 20000
    source = "OANDA"
    batch_size = 2

    batches = [assets[i:i + batch_size] for i in range(0, len(assets), batch_size)]
    all_dfs = []

    with ThreadPoolExecutor(max_workers=6) as executor:
        futures = [executor.submit(process_batch, batch, source, timeframe, n_bars, token) for batch in batches]
        for future in as_completed(futures):
            df = future.result()
            if not df.empty:
                all_dfs.append(df)

    if not all_dfs:
        print("❌ Không có dữ liệu nào.")
        return

    final_df = pd.concat(all_dfs)
    print("✅ Tổng hợp dữ liệu xong:")
    print(final_df.head())

    final_df.set_index(["symbol", "datetime"], inplace=True)

    now = datetime.datetime.now()
    folder = Path("data") / now.strftime("%Y/%m/%d") / timeframe
    folder.mkdir(parents=True, exist_ok=True)
    file_path = folder / f"ohlc_{timeframe}_{now.strftime('%H%M')}.csv"
    final_df.to_csv(file_path)
    now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"\n[{now_str}] ✅ Lưu {len(final_df):,} dòng vào: {file_path}")


    table_name = get_table_from_timeframe(timeframe)
    insert_to_db(final_df, table_name)


if __name__ == "__main__":
    main()

import json
import random
import string
import datetime
import re
import pandas as pd
import sys
import time
from websocket import create_connection
from concurrent.futures import ThreadPoolExecutor, as_completed

def gen_session(prefix="cs"):
    return prefix + "_" + "".join(random.choices(string.ascii_lowercase, k=12))

def prepend_header(msg):
    return f"~m~{len(msg)}~m~{msg}"

def create_message(method, params):
    return json.dumps({"m": method, "p": params}, separators=(",", ":"))

def parse_series(raw_data, symbol):
    try:
        out = re.search('"s":\[(.+?)\}\]', raw_data).group(1)
        x = out.split(',{"')
        data = []
        for xi in x:
            xi = re.split("\\[|:|,|\\]", xi)
            ts = datetime.datetime.fromtimestamp(float(xi[4]))
            row = [symbol, ts] + [float(xi[i]) for i in range(5, 10)]
            data.append(row)
        df = pd.DataFrame(data, columns=["symbol", "datetime", "open", "high", "low", "close", "volume"])
        return df
    except Exception as e:
        print(f"\u274c Parse error for {symbol}:", e)
        return pd.DataFrame()

def process_batch(symbols, source, timeframe, n_bars, token, max_retries=1):
    for attempt in range(1, max_retries + 1):
        try:
            print(f"\n\U0001f680 Processing batch: {symbols} (Lần thử {attempt}/{max_retries})")
            ws = create_connection("wss://data.tradingview.com/socket.io/websocket", timeout=10)
            if not ws.connected:
                raise ConnectionError("Không thể kết nối WebSocket")

            def send(method, params):
                msg = prepend_header(create_message(method, params))
                ws.send(msg)

            send("set_auth_token", [token])
            quote_session = gen_session("qs")
            send("quote_create_session", [quote_session])
            for symbol in symbols:
                send("quote_add_symbols", [quote_session, f"{source}:{symbol}", {"flags": ["force_permission"]}])

            raw_data = {}
            completed = set()

            for i, symbol in enumerate(symbols):
                chart_session = gen_session("cs")
                send("chart_create_session", [chart_session, ""])
                sym_id = f"symbol_{i}"
                series_id = f"s{i}"
                send("resolve_symbol", [
                    chart_session, sym_id,
                    f'={{"symbol":"{source}:{symbol}","adjustment":"splits","session":"regular"}}'
                ])
                send("create_series", [chart_session, series_id, series_id, sym_id, timeframe, n_bars])
                raw_data[symbol] = ""

            while True:
                try:
                    res = ws.recv()
                    for i, symbol in enumerate(symbols):
                        if f'"s{i}"' in res:
                            raw_data[symbol] += res + "\n"
                            if "series_completed" in res and symbol not in completed:
                                completed.add(symbol)
                    if len(completed) == len(symbols):
                        break
                except Exception as e:
                    print(f"\u26a0\ufe0f WebSocket error trong quá trình nhận dữ liệu: {e}")
                    raise

            all_df = []
            for symbol in symbols:
                print(f"\U0001f4c8 Dữ liệu nến cho {symbol}:")
                df = parse_series(raw_data[symbol], symbol)
                print(df.head())
                all_df.append(df)

            ws.close()
            return pd.concat(all_df) if all_df else pd.DataFrame()

        except Exception as e:
            print(f"\u274c Lỗi trong process_batch (attempt {attempt}/{max_retries}): {e}")
            time.sleep(10)

    print("\u274c Đã vượt quá số lần thử lại, bỏ qua batch này.")
    return pd.DataFrame()

def main():
    tokenFilePath = r"./files/forex_key.json"
    with open(tokenFilePath, "r") as file:
        token = json.load(file)["tradingview"]["sen07"]["token"]

    assetFilePath = r"./files/assets.json"
    with open(assetFilePath, "r") as file:
        symbols = list(json.load(file)['symbols']['oanda'].values())
        symbols = symbols[:]

    timeframe = sys.argv[1] if len(sys.argv) > 1 else "1D"
    n_bars = 20000
    source = "OANDA"

    batch_size = 5
    all_batches_df = []

    batches = [symbols[i:i+batch_size] for i in range(0, len(symbols), batch_size)]

    with ThreadPoolExecutor(max_workers=6) as executor:
        futures = [executor.submit(process_batch, batch, source, timeframe, n_bars, token) for batch in batches]
        for future in as_completed(futures):
            df_batch = future.result()
            if not df_batch.empty:
                all_batches_df.append(df_batch)

    if all_batches_df:
        final_df = pd.concat(all_batches_df)
        final_df.set_index(["symbol", "datetime"], inplace=True)
        print("\n\u2705 Dữ liệu tổng hợp:")
        print(final_df)
        date_suffix = datetime.datetime.now().strftime("%Y%m%d")
        final_df.to_csv(f"result_{timeframe}_{date_suffix}.csv")
    else:
        print("\u274c Không lấy được dữ liệu nào.")

if __name__ == "__main__":
    main()

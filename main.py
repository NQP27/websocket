import json
import random
import string
import datetime
import re
import pandas as pd
from websocket import create_connection


def gen_session(prefix="cs"):
    return prefix + "_" + "".join(random.choices(string.ascii_lowercase, k=12))


def prepend_header(msg):
    return f"~m~{len(msg)}~m~{msg}"


def create_message(method, params):
    return json.dumps({"m": method, "p": params}, separators=(",", ":"))


def parse_series(raw_data):
    try:
        out = re.search('"s":\[(.+?)\}\]', raw_data).group(1)
        x = out.split(',{"')
        data = []
        for xi in x:
            xi = re.split("\[|:|,|\]", xi)
            ts = datetime.datetime.fromtimestamp(float(xi[4]))
            row = [ts] + [float(xi[i]) for i in range(5, 10)]
            data.append(row)
        df = pd.DataFrame(data, columns=["datetime", "open", "high", "low", "close", "volume"])
        df.set_index("datetime", inplace=True)
        return df
    except Exception as e:
        print("Parse error:", e)
        return pd.DataFrame()  # return empty DF on error


def main():
    filePath = r"./files/forex_key.json"
    with open(filePath, "r") as file:
            infor = json.load(file)
            token = infor["tradingview"]["sen07"]["token"]
    symbol = "EURUSD"
    source = "OANDA"
    timeframe = "1D"  # 1m
    n_bars = 100

    # Replace this with your sessionid cookie from TradingView
    chart_session = gen_session("cs")
    quote_session = gen_session("qs")

    ws = create_connection("wss://data.tradingview.com/socket.io/websocket", timeout=5)

    def send(method, params):
        msg = prepend_header(create_message(method, params))
        ws.send(msg)

    # 1. Auth
    send("set_auth_token", [token])

    # 2. Create sessions
    send("chart_create_session", [chart_session, ""])
    send("quote_create_session", [quote_session])
    send("quote_add_symbols", [quote_session, f"{source}:{symbol}", {"flags": ["force_permission"]}])

    # 3. Resolve symbol & request data
    send("resolve_symbol", [
        chart_session, "symbol_1",
        f'={{"symbol":"{source}:{symbol}","adjustment":"splits","session":"regular"}}'
    ])
    send("create_series", [chart_session, "s1", "s1", "symbol_1", timeframe, n_bars])

    print(f"Lấy dữ liệu nến {symbol} khung {timeframe}...")

    raw = ""
    while True:
        try:
            res = ws.recv()
            raw += res + "\n"
            if "series_completed" in res:
                break
        except Exception as e:
            print("Lỗi:", e)
            break

    candles = parse_series(raw)
    # for row in candles[:]:
    print(candles)


if __name__ == "__main__":
    main()

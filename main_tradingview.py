import subprocess
import sys
import time
from datetime import datetime, timezone
import logging
from logging.handlers import RotatingFileHandler

from constants.enum import TimeframesTv

# Cấu hình log
logger = logging.getLogger("Scheduler")
logger.setLevel(logging.INFO)

log_handler = RotatingFileHandler("scheduler.log", maxBytes=5*1024*1024, backupCount=3, encoding="utf-8")
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
log_handler.setFormatter(formatter)
logger.addHandler(log_handler)

# Mapping timeframe -> điều kiện trigger chạy
timeframe_conditions = {
    TimeframesTv.M1: lambda dt: True,
    TimeframesTv.M5: lambda dt: dt.minute % 5 == 0,
    TimeframesTv.M15: lambda dt: dt.minute % 5 == 0,
    TimeframesTv.M30: lambda dt: dt.minute % 11 == 0,
    TimeframesTv.H1: lambda dt: dt.minute % 11 == 0,
    TimeframesTv.H4: lambda dt: dt.minute % 17 == 0,
    TimeframesTv.H12: lambda dt: dt.minute % 17 == 0,
    TimeframesTv.D1: lambda dt: dt.minute % 23 == 0,
    TimeframesTv.W1: lambda dt: dt.minute % 23 == 0,
    TimeframesTv.MN1: lambda dt: dt.minute % 29 == 0,
}

# Lưu trạng thái lỗi liên tục
error_counts = {tf: 0 for tf in TimeframesTv}
ERROR_THRESHOLD = 3  # Số lần lỗi liên tiếp để gửi cảnh báo

def send_alert(timeframe, error_msg):
    # Đây là ví dụ gửi alert qua email, hoặc gọi API Telegram, Slack, v.v
    # Ở đây mình chỉ ghi log cảnh báo thôi, bạn có thể mở rộng
    alert_msg = f"[ALERT] Lỗi liên tiếp quá {ERROR_THRESHOLD} lần ở timeframe {timeframe.name}: {error_msg}"
    logger.error(alert_msg)
    print(alert_msg)

def run_timeframe(timeframe):
    global error_counts
    try:
        logger.info(f"Starting timeframe: {timeframe.name}")
        subprocess.run(
            [sys.executable, "websocket_tradingview_ohlc.py", timeframe.value],
            check=True,
            text=True,
            encoding="utf-8",
            errors="replace"
        )
        logger.info(f"Completed timeframe: {timeframe.name}")
        error_counts[timeframe] = 0  # reset lỗi sau khi thành công
    except subprocess.CalledProcessError as e:
        error_counts[timeframe] += 1
        err_msg = e.stderr or str(e)
        logger.error(f"Error in timeframe {timeframe.name}: {err_msg}")
        if error_counts[timeframe] >= ERROR_THRESHOLD:
            send_alert(timeframe, err_msg)

def main():
    logger.info("Scheduler started.")
    print("Scheduler running, check scheduler.log for details.")

    while True:
        now = datetime.now(timezone.utc)
        logger.info(f"Current time (UTC): {now.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"\n🕐 {now.strftime('%Y-%m-%d %H:%M:%S')} UTC")
        for tf, condition in timeframe_conditions.items():
            if condition(now):
                print(f"⏳ Trigger timeframe: {tf.name}")
                run_timeframe(tf)

        time.sleep(60)

if __name__ == "__main__":
    main()

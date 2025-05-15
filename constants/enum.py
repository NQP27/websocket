from enum import Enum

class TimeframesTv(Enum):
    M1 = "1"
    M5 = "5"
    M15 = "15"
    M30 = "30"
    # M45 = "45"
    H1 = "60"
    # H2 = "120"
    # H3 = "180"
    H4 = "240"
    H12 = "720"
    D1 = "D"
    W1 = "W"
    MN1 = "M"
    
    
class Tables(Enum):
    MN1 = "ohlc_month"
    W1 = "ohlc_week"
    D1 = "ohlc_day"
    H12 = "ohlc_h12"
    H4 = "ohlc_h4"
    # H2 = "ohlc_h2"
    H1 = "ohlc_h1"
    # M45 = "ohlc_m45"
    M30 = "ohlc_m30"
    M15 = "ohlc_m15"
    M5 = "ohlc_m5"
    M1 = "ohlc_m1"
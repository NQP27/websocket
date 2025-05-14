CREATE TABLE IF NOT EXISTS dwh.order_book (
    symbol TEXT NOT NULL,
    event_time TIMESTAMPTZ NOT NULL,
    side TEXT NOT NULL, -- 'bid' hoặc 'ask'
    price DOUBLE PRECISION NOT NULL,
    quantity DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (symbol, event_time, side, price)  -- phòng chống conflict
);

SELECT create_hypertable('dwh.order_book', 'event_time', if_not_exists => TRUE);

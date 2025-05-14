CREATE TABLE IF NOT EXISTS dwh."tick_data" (
    trade_id BIGINT,
    event_time TIMESTAMPTZ NOT NULL,
    symbol TEXT NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    quantity DOUBLE PRECISION NOT NULL,
    is_buyer_maker BOOLEAN,
    trade_time TIMESTAMPTZ NOT null,
    PRIMARY KEY (trade_id, event_time) 
);

SELECT create_hypertable('dwh.tick_data', 'event_time', if_not_exists => TRUE);
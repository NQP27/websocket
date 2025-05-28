
CREATE SCHEMA IF NOT EXISTS staging;

DO $$
DECLARE
    tf TEXT;
    tbl TEXT;
BEGIN
    FOREACH tf IN ARRAY ARRAY['m1', 'm5', 'm15', 'm30', 'h1', 'h4', 'h12', 'day', 'week', 'month']
    LOOP
        tbl := format('staging.ohlc_%I', tf);

        -- Tạo bảng
        EXECUTE format($f$
            CREATE TABLE IF NOT EXISTS %s (
                id BIGSERIAL,  -- Tự động tăng
                symbol VARCHAR(10),
                prename VARCHAR(50),
                broker VARCHAR(50), 
                data_source VARCHAR(30),
                open DECIMAL(11,5),
                close DECIMAL(11,5),
                high DECIMAL(11,5),
                low DECIMAL(11,5),
                co DECIMAL(11,5),
                hl DECIMAL(11,5),
                tick_vol DECIMAL(15,1),
                datetime TIMESTAMPTZ NOT NULL,
                direction VARCHAR(10),
                PRIMARY KEY (symbol, datetime)  -- Phải bao gồm datetime
            );
        $f$, tbl);

        -- Tạo hypertable
        BEGIN
            EXECUTE format(
                'SELECT create_hypertable(''%s'', ''datetime'', if_not_exists => TRUE);',
                tbl
            );
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END LOOP;
END $$;

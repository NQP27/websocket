-- Tạo schema
CREATE SCHEMA IF NOT EXISTS staging;

DO $$
DECLARE
    tf TEXT;
BEGIN
    FOREACH tf IN ARRAY ARRAY['m1', 'm5', 'm15', 'm30', 'h1', 'h4', 'h12', 'day', 'week', 'month']
    LOOP
        EXECUTE format($f$
            CREATE TABLE IF NOT EXISTS staging."ohlc_%1$I" (
                id BIGSERIAL PRIMARY KEY,
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
                direction VARCHAR(10)
            );
            DO $inner$
            BEGIN
                PERFORM create_hypertable('staging.ohlc_%1$I', 'datetime', if_not_exists => TRUE);
            EXCEPTION WHEN OTHERS THEN
                -- Ignore errors if hypertable already exists
                NULL;
            END;
            $inner$;
        $f$, tf);
    END LOOP;
END $$;


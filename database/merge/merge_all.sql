-- MERGE M1
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_m1 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_m1
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE M5
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_m5 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_m5
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE M15
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_m15 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_m15
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE M30
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_m30 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_m30
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE H1
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_h1 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_h1
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE H4
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_h4 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_h4
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE H12
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_h12 AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_h12
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE DAY
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_day AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_day
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE WEEK
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_week AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_week
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT;

-- MERGE MONTH
BEGIN TRANSACTION;
MERGE INTO master.dwh.ohlc_month AS target
USING (
    SELECT 
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    FROM master.staging.ohlc_month
) AS source
ON target.asset_id = source.asset_id
   AND target.[datetime] = source.[datetime]
   AND target.broker = source.broker
WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        asset_id, data_source, broker, account_type, account_name,
        [open], [close], high, low, co, hl, tick_vol, real_vol, [datetime], direction
    )
    VALUES (
        source.asset_id, source.data_source, source.broker, source.account_type, source.account_name,
        source.[open], source.[close], source.high, source.low, source.co, source.hl,
        source.tick_vol, source.real_vol, source.[datetime], source.direction
    )
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
COMMIT; 
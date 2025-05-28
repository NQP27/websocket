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
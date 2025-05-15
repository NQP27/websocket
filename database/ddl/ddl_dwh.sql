


create schema dwh;


-- master.dwh.assets definition

-- Drop table

-- DROP TABLE master.dwh.assets;

CREATE TABLE master.dwh.assets (
	id bigint IDENTITY(1,1) NOT NULL,
	symbol varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	prename varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	us_open time NULL,
	us_close time NULL,
	asia_open time NULL,
	asia_close time NULL,
	eu_open time NULL,
	eu_close time NULL,
	sydney_open time NULL,
	sydney_close time NULL,
	season_ref date NULL,
	CONSTRAINT PK__assets__3213E83F76C0D637 PRIMARY KEY (id)
);


-- master.dwh.ohlc_day definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_day;

CREATE TABLE master.dwh.ohlc_day (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	CONSTRAINT PK__ohlc_day__3213E83FB9D96AC3 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_day ON master.dwh.ohlc_day (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_h1 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_h1;

CREATE TABLE master.dwh.ohlc_h1 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	id_h12 bigint NULL,
	id_h4 bigint NULL,
	CONSTRAINT PK__ohlc_h1__3213E83F567F85E4 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_h1 ON master.dwh.ohlc_h1 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_h12 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_h12;

CREATE TABLE master.dwh.ohlc_h12 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	CONSTRAINT PK__ohlc_h12__3213E83F8F6B9D6B PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_h12 ON master.dwh.ohlc_h12 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_h4 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_h4;

CREATE TABLE master.dwh.ohlc_h4 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	id_h12 bigint NULL,
	CONSTRAINT PK__ohlc_h4__3213E83FD90009D4 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_h4 ON master.dwh.ohlc_h4 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



-- master.dwh.ohlc_m1 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_m1;

CREATE TABLE master.dwh.ohlc_m1 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	id_h12 bigint NULL,
	id_h4 bigint NULL,
	id_h1 bigint NULL,
	id_m30 bigint NULL,
	id_m15 bigint NULL,
	id_m5 bigint NULL,
	CONSTRAINT PK__ohlc_m1__3213E83FD6885410 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_m1 ON master.dwh.ohlc_m1 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_m15 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_m15;

CREATE TABLE master.dwh.ohlc_m15 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	id_h12 bigint NULL,
	id_h4 bigint NULL,
	id_h1 bigint NULL,
	id_m30 bigint NULL,
	CONSTRAINT PK__ohlc_m15__3213E83F8B03DE80 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_m15 ON master.dwh.ohlc_m15 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_m30 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_m30;

CREATE TABLE master.dwh.ohlc_m30 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	id_h12 bigint NULL,
	id_h4 bigint NULL,
	id_h1 bigint NULL,
	CONSTRAINT PK__ohlc_m30__3213E83FD6EC870D PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_m30 ON master.dwh.ohlc_m30 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_m5 definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_m5;

CREATE TABLE master.dwh.ohlc_m5 (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	id_week bigint NULL,
	id_day bigint NULL,
	id_h12 bigint NULL,
	id_h4 bigint NULL,
	id_h1 bigint NULL,
	id_m30 bigint NULL,
	id_m15 bigint NULL,
	CONSTRAINT PK__ohlc_m5__3213E83F238C9FD6 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_m5 ON master.dwh.ohlc_m5 (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- master.dwh.ohlc_month definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_month;

CREATE TABLE master.dwh.ohlc_month (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__ohlc_mon__3213E83FEA669BE1 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_month ON master.dwh.ohlc_month (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



-- master.dwh.ohlc_week definition

-- Drop table

-- DROP TABLE master.dwh.ohlc_week;

CREATE TABLE master.dwh.ohlc_week (
	id bigint IDENTITY(1,1) NOT NULL,
	asset_id bigint NULL,
	data_source varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	broker varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	account_name varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open] decimal(11,5) NULL,
	[close] decimal(11,5) NULL,
	high decimal(11,5) NULL,
	low decimal(11,5) NULL,
	co decimal(11,5) NULL,
	hl decimal(11,5) NULL,
	tick_vol decimal(15,1) NULL,
	real_vol decimal(15,1) NULL,
	[datetime] datetime NULL,
	direction varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	id_month bigint NULL,
	CONSTRAINT PK__ohlc_wee__3213E83F5E643A24 PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX idx_composite_ohlc_week ON master.dwh.ohlc_week (  asset_id ASC  , data_source ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;



INSERT INTO master.dwh.assets (symbol, prename) VALUES
('EU', 'EURUSD'),
('GU', 'GBPUSD'),
('AU', 'AUDUSD'),
('NU', 'NZDUSD'),
('UJ', 'USDJPY'),
('UCAD', 'USDCAD'),
('UCHF', 'USDCHF'),
('GOLD', 'XAUUSD'),
('DJ', 'US30'),
('NASDAQ', 'NAS100'),
('SPX', 'SP500'),
('NIKKEI225', 'N225'),
('DAX40', 'DAX30'),
('CAC40', 'CAC40'),
('FTSE100', 'FTSE100'),
('FTSEMIB', 'FTSEMIB'),
('IBEX35', 'IBEX35'),
('ASX200', 'ASX200')
;


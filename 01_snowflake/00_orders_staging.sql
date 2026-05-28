-- =============================================================
-- File: 00_orders_staging.sql
-- Purpose:
--   Stage Snowflake TPCH ORDERS sample data into a local table
--   with Time Travel enabled. This provides a stable, time-aware
--   source for downstream Dynamic Tables.
--
-- Design notes:
--   - Ingestion (COPY / Snowpipe) is intentionally out of scope
--   - Column names are normalized at the platform boundary
-- =============================================================

CREATE OR REPLACE TABLE ARCH_BSG_DYNAMIC_TABLES.ORDERS_STG
DATA_RETENTION_TIME_IN_DAYS = 1
AS
SELECT
    O_ORDERKEY   AS order_id,
    O_CUSTKEY    AS customer_id,
    O_ORDERDATE  AS order_ts,
    O_TOTALPRICE AS amount
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

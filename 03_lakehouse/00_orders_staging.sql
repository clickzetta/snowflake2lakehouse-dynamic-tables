-- =============================================================
-- File: 00_orders_staging.sql
-- Purpose:
--   Stage Lakehouse TPCH ORDERS sample data into a local table
--   with Time Travel enabled. This provides a stable, time-aware
--   source for downstream Dynamic Tables.
--
-- Design notes:
--   - Ingestion (Pipe / Studio Realtime Sync) is intentionally out of scope
--   - Column names are normalized at the platform boundary
--
-- Migration notes (Snowflake → Lakehouse):
--   SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
--     → clickzetta_sample_data.tpch_100g.orders
--       Lakehouse ships a built-in shared dataset under clickzetta_sample_data.
--       tpch_100g uses the 100GB scale factor (vs SF1 = 1GB in Snowflake).
--
--   DATA_RETENTION_TIME_IN_DAYS = 1  (inline DDL option)
--     → ALTER TABLE ... SET PROPERTIES ('data_retention_days' = '1')
--       Lakehouse sets Time Travel retention via table properties,
--       not as an inline DDL clause on CREATE TABLE.
--
--   Schema: ARCH_BSG_DYNAMIC_TABLES → bsg_dynamic_tables
--       Lakehouse has no multi-level database; use a single schema name.
-- =============================================================

CREATE SCHEMA IF NOT EXISTS bsg_dynamic_tables;

CREATE OR REPLACE TABLE bsg_dynamic_tables.orders_stg
AS
SELECT
    O_ORDERKEY   AS order_id,
    O_CUSTKEY    AS customer_id,
    O_ORDERDATE  AS order_ts,
    O_TOTALPRICE AS amount
FROM clickzetta_sample_data.tpch_100g.orders;

ALTER TABLE bsg_dynamic_tables.orders_stg
SET PROPERTIES ('data_retention_days' = '1');

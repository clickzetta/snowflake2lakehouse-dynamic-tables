-- =============================================================
-- File: 02_silver_dynamic_table.sql
-- Purpose:
--   Silver layer Dynamic Table.
--   Provides cleansed, standardized, and deduplicated data.
--
-- Design principles:
--   - No aggregations
--   - No business semantics
--   - Focus on data correctness and consistency
--
-- Migration notes (Snowflake → Lakehouse):
--   TARGET_LAG / WAREHOUSE  → see 01_bronze_dynamic_table.sql
--   QUALIFY ROW_NUMBER() OVER (...) = 1
--       Supported in Lakehouse with the same syntax and semantics.
--   CAST(order_ts AS TIMESTAMP)
--       order_ts is DATE in the source; CAST to TIMESTAMP is supported.
-- =============================================================

CREATE OR REPLACE DYNAMIC TABLE bsg_dynamic_tables.silver_orders
  REFRESH INTERVAL '5' MINUTE
  VCLUSTER default
AS
SELECT
    order_id,
    customer_id,
    CAST(order_ts AS TIMESTAMP) AS order_ts,
    amount,
    ingestion_ts,
    source_system
FROM bsg_dynamic_tables.bronze_orders
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY order_id
    ORDER BY ingestion_ts DESC
) = 1;

REFRESH DYNAMIC TABLE bsg_dynamic_tables.silver_orders;

-- =============================================================
-- File: 03_gold_dynamic_table.sql
-- Purpose:
--   Gold layer Dynamic Table.
--   Business-ready aggregated data for analytics and reporting.
--
-- Design principles:
--   - Stable, well-defined grain (daily)
--   - Simple, explainable metrics
--   - Optimized for consumption
--
-- Migration notes (Snowflake → Lakehouse):
--   TARGET_LAG / WAREHOUSE  → see 01_bronze_dynamic_table.sql
--   DATE_TRUNC('day', order_ts)
--       Supported in Lakehouse with the same syntax and semantics.
-- =============================================================

CREATE OR REPLACE DYNAMIC TABLE bsg_dynamic_tables.gold_sales_summary
  REFRESH INTERVAL '10' MINUTE
  VCLUSTER default
AS
SELECT
    DATE_TRUNC('day', order_ts) AS order_date,
    COUNT(*)                    AS total_orders,
    SUM(amount)                 AS total_sales
FROM bsg_dynamic_tables.silver_orders
GROUP BY DATE_TRUNC('day', order_ts);

REFRESH DYNAMIC TABLE bsg_dynamic_tables.gold_sales_summary;

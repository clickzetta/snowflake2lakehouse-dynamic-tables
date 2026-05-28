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
-- =============================================================

CREATE OR REPLACE DYNAMIC TABLE gold_sales_summary
  TARGET_LAG = '10 minutes'
  WAREHOUSE = compute_wh
AS
SELECT
    DATE_TRUNC('day', order_ts) AS order_date,
    COUNT(*)                   AS total_orders,
    SUM(amount)                AS total_sales
FROM silver_orders
GROUP BY DATE_TRUNC('day', order_ts);

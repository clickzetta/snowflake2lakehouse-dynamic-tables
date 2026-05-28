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
-- =============================================================

CREATE OR REPLACE DYNAMIC TABLE silver_orders
  TARGET_LAG = '5 minutes'
  WAREHOUSE = compute_wh
AS
SELECT
    order_id,
    customer_id,
    CAST(order_ts AS TIMESTAMP) AS order_ts,
    amount,
    ingestion_ts,
    source_system
FROM bronze_orders
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY order_id
    ORDER BY ingestion_ts DESC
) = 1;

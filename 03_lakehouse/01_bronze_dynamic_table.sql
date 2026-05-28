-- =============================================================
-- File: 01_bronze_dynamic_table.sql
-- Purpose:
--   Bronze layer Dynamic Table.
--   Represents raw-but-governed data with minimal transformation.
--
-- Design principles:
--   - No business logic
--   - Trust upstream schema contract
--   - Capture lineage and ingestion metadata
--
-- Migration notes (Snowflake → Lakehouse):
--   USE SCHEMA ARCH_BSG_DYNAMIC_TABLES  → removed; use fully-qualified names
--   TARGET_LAG = '5 minutes'            → REFRESH INTERVAL '5' MINUTE
--       Snowflake uses TARGET_LAG to declare acceptable staleness;
--       Lakehouse uses REFRESH INTERVAL to set a fixed refresh cadence.
--       There is no DOWNSTREAM dependency model in Lakehouse — each
--       Dynamic Table refreshes independently on its own interval.
--   WAREHOUSE = compute_wh              → VCLUSTER default
--       Snowflake Virtual Warehouse maps to Lakehouse VCluster.
--       Use the name of your VCluster (default in most instances).
-- =============================================================

CREATE OR REPLACE DYNAMIC TABLE bsg_dynamic_tables.bronze_orders
  REFRESH INTERVAL '5' MINUTE
  VCLUSTER default
AS
SELECT
    src.order_id,
    src.customer_id,
    src.order_ts,
    src.amount,
    CURRENT_TIMESTAMP() AS ingestion_ts,
    'TPCH_ORDERS'       AS source_system
FROM bsg_dynamic_tables.orders_stg src;

-- Trigger initial refresh
-- Migration note: Snowflake uses ALTER DYNAMIC TABLE ... REFRESH
--   Lakehouse uses REFRESH DYNAMIC TABLE <name>
REFRESH DYNAMIC TABLE bsg_dynamic_tables.bronze_orders;

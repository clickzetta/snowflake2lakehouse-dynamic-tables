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
-- =============================================================

USE SCHEMA ARCH_BSG_DYNAMIC_TABLES;

CREATE OR REPLACE DYNAMIC TABLE bronze_orders
  TARGET_LAG = '5 minutes'
  WAREHOUSE = compute_wh
AS
SELECT
    src.order_id,
    src.customer_id,
    src.order_ts,
    src.amount,

    -- Governance / lineage metadata
    CURRENT_TIMESTAMP() AS ingestion_ts,
    'TPCH_ORDERS'       AS source_system
FROM ORDERS_STG src;

/*-----------------------------------------------------------------------------
Lakehouse Migration: Dynamic Tables BSG Pipeline
Script:       06_cleanup.sql
Migrated from: (no equivalent in original project)

Drops all objects created by this project.

Run with:
  cz-cli sql -f 03_lakehouse/06_cleanup.sql --profile <your-profile> --sync --write
-----------------------------------------------------------------------------*/

-- Drop Dynamic Tables first (they depend on orders_stg)
DROP DYNAMIC TABLE IF EXISTS bsg_dynamic_tables.gold_sales_summary;
DROP DYNAMIC TABLE IF EXISTS bsg_dynamic_tables.silver_orders;
DROP DYNAMIC TABLE IF EXISTS bsg_dynamic_tables.bronze_orders;

-- Drop staging table
DROP TABLE IF EXISTS bsg_dynamic_tables.orders_stg;

-- Drop schema (drops all remaining objects inside)
DROP SCHEMA IF EXISTS bsg_dynamic_tables;

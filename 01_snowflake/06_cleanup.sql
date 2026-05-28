/*-----------------------------------------------------------------------------
Snowflake BSG Dynamic Tables
Script:       06_cleanup.sql

Drops all objects created by this project.

Run in Snowsight or SnowSQL:
  USE ROLE lab_role;
  USE DATABASE tasty_bytes_db;
-----------------------------------------------------------------------------*/

USE ROLE lab_role;
USE DATABASE tasty_bytes_db;

-- Drop Dynamic Tables (analytics schema)
DROP DYNAMIC TABLE IF EXISTS tasty_bytes_db.analytics.gold_sales_summary;
DROP DYNAMIC TABLE IF EXISTS tasty_bytes_db.analytics.product_performance_metrics;
DROP DYNAMIC TABLE IF EXISTS tasty_bytes_db.analytics.daily_business_metrics;
DROP DYNAMIC TABLE IF EXISTS tasty_bytes_db.analytics.order_fact;
DROP DYNAMIC TABLE IF EXISTS tasty_bytes_db.analytics.order_items_enriched;
DROP DYNAMIC TABLE IF EXISTS tasty_bytes_db.analytics.orders_enriched;

-- Drop raw tables
DROP TABLE IF EXISTS tasty_bytes_db.raw.order_header;
DROP TABLE IF EXISTS tasty_bytes_db.raw.order_detail;
DROP TABLE IF EXISTS tasty_bytes_db.raw.menu;

-- Drop schemas
DROP SCHEMA IF EXISTS tasty_bytes_db.analytics;
DROP SCHEMA IF EXISTS tasty_bytes_db.raw;

-- Drop database
DROP DATABASE IF EXISTS tasty_bytes_db;

-- Drop warehouse
DROP WAREHOUSE IF EXISTS tasty_bytes_wh;

-- Drop role
USE ROLE ACCOUNTADMIN;
DROP ROLE IF EXISTS lab_role;

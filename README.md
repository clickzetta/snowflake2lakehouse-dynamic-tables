# Snowflake → Lakehouse: Dynamic Tables Migration (BSG Architecture)

This repository is a migration of [Techy-Malay/snowflake-bsg-dynamic-tables](https://github.com/Techy-Malay/snowflake-bsg-dynamic-tables) from Snowflake to [ClickZetta Lakehouse](https://www.clickzetta.com).

It demonstrates a **Bronze–Silver–Gold (BSG) pipeline using Dynamic Tables**, and serves as a concrete reference for teams migrating Snowflake Dynamic Table workloads to Lakehouse.

---

## Migration Summary

| Concept | Snowflake | Lakehouse |
|---------|-----------|-----------|
| Sample dataset | `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS` | `clickzetta_sample_data.tpch_100g.orders` |
| Compute resource | `WAREHOUSE = compute_wh` | `VCLUSTER default` |
| Refresh cadence | `TARGET_LAG = '5 minutes'` | `REFRESH INTERVAL '5' MINUTE` |
| Dependency model | `TARGET_LAG = 'DOWNSTREAM'` (auto-cascade) | No DOWNSTREAM concept; each table refreshes on its own interval |
| Time Travel retention | `DATA_RETENTION_TIME_IN_DAYS = 1` (inline DDL) | `ALTER TABLE ... SET PROPERTIES ('data_retention_days' = '1')` |
| Manual refresh | `ALTER DYNAMIC TABLE ... REFRESH` | `REFRESH DYNAMIC TABLE ...` |
| Deduplication | `QUALIFY ROW_NUMBER() OVER (...) = 1` | Same syntax — fully supported |
| Date truncation | `DATE_TRUNC('day', ts)` | Same syntax — fully supported |
| Schema reference | `USE SCHEMA` + unqualified table names | Fully-qualified names (`schema.table`) |

---

## Architecture

```
clickzetta_sample_data.tpch_100g.orders  (shared dataset, 150M rows)
              │
              ▼
bsg_dynamic_tables.orders_stg            (staging table, CTAS, Time Travel enabled)
              │
              ▼  REFRESH INTERVAL '5' MINUTE
bsg_dynamic_tables.bronze_orders         (raw + lineage metadata)
              │
              ▼  REFRESH INTERVAL '5' MINUTE  +  QUALIFY dedup
bsg_dynamic_tables.silver_orders         (cleansed, deduplicated)
              │
              ▼  REFRESH INTERVAL '10' MINUTE
bsg_dynamic_tables.gold_sales_summary    (daily aggregates, business-ready)
```

---

## File Structure

```
sql/
├── 00_orders_staging.sql        # Create staging table from shared TPCH dataset
├── 01_bronze_dynamic_table.sql  # Bronze layer: raw but governed
├── 02_silver_dynamic_table.sql  # Silver layer: cleansed and deduplicated
└── 03_gold_dynamic_table.sql    # Gold layer: business-ready daily aggregates
```

Each file contains inline migration notes explaining every syntax change.

---

## Verified Results

All SQL was verified against a live Lakehouse instance using `cz-cli`:

| Table | Rows | Notes |
|-------|------|-------|
| `orders_stg` | 100,000 | Sampled from 150M-row TPCH dataset |
| `bronze_orders` | 100,000 | + `ingestion_ts`, `source_system` columns |
| `silver_orders` | 100,000 | QUALIFY dedup — no duplicates in TPCH source |
| `gold_sales_summary` | 103 | 103 distinct order dates, total sales $15.1B |

---

## Key Differences to Note

**No DOWNSTREAM dependency model**

Snowflake's `TARGET_LAG = 'DOWNSTREAM'` lets upstream tables trigger downstream refreshes automatically. Lakehouse does not have this concept — each Dynamic Table refreshes on its own fixed interval. In practice, set Tier 1 intervals shorter than Tier 2/3 to approximate the cascade behavior.

**REFRESH command syntax**

Snowflake uses `ALTER DYNAMIC TABLE <name> REFRESH`. Lakehouse uses `REFRESH DYNAMIC TABLE <name>`. Both trigger an immediate out-of-schedule refresh.

**Data retention is a table property**

Snowflake allows `DATA_RETENTION_TIME_IN_DAYS` as an inline DDL option on `CREATE TABLE`. In Lakehouse, this is set post-creation via `ALTER TABLE ... SET PROPERTIES ('data_retention_days' = 'N')`.

---

## Related Documentation

- [动态表（Dynamic Table）](https://docs.clickzetta.com/dynamic-table)
- [CREATE DYNAMIC TABLE](https://docs.clickzetta.com/create-dynamic-table)
- [Time Travel](https://docs.clickzetta.com/timetravel)

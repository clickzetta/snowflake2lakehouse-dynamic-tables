# Snowflake BSG (Dynamic Tables)

## 1. Project Overview

This project demonstrates a **Snowflake-native implementation of the Bronze–Silver–Gold (BSG) architecture using Dynamic Tables**.

The focus of this repository is **architecture and platform design**, not operational pipeline implementation. It is intentionally structured to explain **how and why** Dynamic Tables should be used to design clean, maintainable BSG layers in Snowflake.

---

## 2. Project Intent & Context

This repository is **deliberately different** from my earlier Dynamic Tables project.

* **Earlier project**: Focused on building a **production-ready data engineering pipeline**, including end-to-end execution and operational aspects such as notifications and monitoring.

* **This project**: Focuses on **platform and architectural design** — how to correctly structure Bronze–Silver–Gold layers using Snowflake Dynamic Tables, define responsibility boundaries, and rely on Snowflake’s execution model rather than custom or user-managed orchestration.

The intent here is to demonstrate **design judgment**, specifically:

* When *not* to add operational complexity
* How to keep responsibilities clean across Bronze, Silver, and Gold layers
* How Dynamic Tables change the way BSG pipelines are reasoned about

The SQL included in this repository is **intentionally minimal and illustrative**. It exists to clarify layer intent, not to represent a full production pipeline.

Together, these two projects represent **complementary perspectives**:

* Building and operating data pipelines
* Designing data platforms with long-term correctness and maintainability in mind

---

## 3. Architecture Overview

![Snowflake BSG Architecture using Dynamic Tables](architecture/bsg-dynamic-tables-architecture.png)

The pipeline follows a linear, dependency-driven flow:

**Source → Bronze Dynamic Table → Silver Dynamic Table → Gold Dynamic Table**

Key architectural characteristics:

* Each layer is implemented as a Dynamic Table
* Refresh is dependency-based, not schedule-driven
* No Tasks or Streams are used
* Warehouses are assigned deliberately to balance cost and performance

This architecture emphasizes **clarity, traceability, and operational simplicity** over complexity.

Dynamic Tables are used to allow Snowflake to manage refresh order and incremental processing.
The platform automatically maintains dependencies across Bronze, Silver, and Gold layers without user-managed orchestration.


---

## 4. Implementation Outline
[File structure list]

The SQL implementation for this project is organized as follows:

```text
sql/
├── 00_orders_staging.sql        # Stage sample data with Time Travel enabled
├── 01_bronze_dynamic_table.sql  # Bronze layer: raw but governed
├── 02_silver_dynamic_table.sql  # Silver layer: cleansed and deduplicated
└── 03_gold_dynamic_table.sql    # Gold layer: business-ready aggregates
```


---


## 5. Bronze Layer — Raw but Governed

The Bronze layer represents raw data ingestion with governance.

Design principles:

* Data is ingested in its original granularity
* Schema is enforced to avoid ambiguity
* Ingestion timestamps and source metadata are captured
* Transformations are intentionally minimal

Bronze is designed to be **reproducible and traceable**, not a dumping ground.

---

## 6. Silver Layer — Cleaned and Standardized

The Silver layer focuses on data correctness and consistency.

Responsibilities include:

* Deduplication
* Standardization of formats and data types
* Basic data quality validation

What is explicitly avoided:

* Complex joins
* Business rules
* Aggregations

This separation keeps reprocessing fast and debugging manageable.

---

## 7. Gold Layer — Business-Ready Analytics

The Gold layer serves analytical and reporting workloads.

Characteristics:

* Aggregated and query-optimized tables
* Stable schemas designed for consumption
* Clear alignment with business metrics

Gold tables are designed so that **consumers do not need to bypass them**.

---

## 8. Refresh Strategy & Execution Model

Dynamic Tables refresh based on declared freshness and upstream dependencies.

Key points:

* Downstream tables refresh automatically when upstream data changes
* Execution order is handled by Snowflake
* Orchestration logic is removed from user-managed code

This reduces operational complexity and improves reliability.

---

## 9. Key Design Decisions

* Dynamic Tables were chosen over Tasks and Streams for simplicity and maintainability
* Transformations are minimized in early layers to keep reprocessing cheap
* Gold tables are intentionally opinionated and business-focused
* Cost and performance trade-offs are evaluated per layer

---

## 10. What This Project Demonstrates

* Snowflake Dynamic Tables
* Medallion (BSG) architecture principles
* Data engineering best practices
* Cost-aware pipeline design
* Architect-level decision making

---

## 11. Author

**Malaya Padhi** *(pronounced: Malay)*
Principal Architect (Aspirational) | Snowflake • Data Architecture • Data Engineering

This project reflects hands-on architectural thinking around Snowflake Dynamic Tables, Medallion Architecture, and production-oriented data pipeline design, with a clear progression toward Principal Architect–level responsibilities.

---

## 12. References & Notes

This project is conceptually aligned with common industry discussions on Medallion Architecture and demonstrates a **Snowflake-specific implementation using Dynamic Tables**.

# ModelFlow — Multi-Architecture Data Modeling Workshop

> **dbt + DuckDB** · Data Vault 2.0 · Inmon 3NF · Star Schema

A comprehensive data engineering workspace demonstrating **three parallel modeling methodologies** on a shared e-commerce dataset using a Bronze → Silver → Gold medallion architecture.

---

## 🏗️ Architecture Overview

```
seeds/ (raw_customers, raw_products, raw_orders, raw_shipments)
    └──► Bronze (Views): Staging & Hash Key computation
             └──► Silver (Tables): Core modeling per methodology
                      └──► Gold (Tables): Business-ready outputs

Three parallel paths from the same Bronze source:
  ├── DataVault/   → Hubs  → Links  → Satellites  → Business Vault
  ├── Inmon3NF/   → 3NF Entities → CDW Fact      → Reporting Aggregations
  └── StarSchema/ → SCD2 Dims + Date → Fact Sales → BI Marts
```

---

## 📋 Prerequisites

Ensure the following tools are installed before proceeding:

| Tool | Minimum Version | Purpose |
|---|---|---|
| [Git](https://git-scm.com/) | 2.x | Clone the repository |
| [Python](https://www.python.org/) | 3.11+ | Runtime for dbt and data generation |
| [uv](https://docs.astral.sh/uv/) | latest | Python package & environment manager |

---

## ⚡ Quick Start

### Step 0 — Clone the repository

```bash
git clone git@code.euranova.eu:data-modeling-workshop/modelflow.git
cd modelflow
```

### Step 1 — Create the virtual environment and install dependencies

```bash
uv sync

source .venv/bin/activate
```

### Step 2 — Verify the dbt connection

```bash
dbt debug --profiles-dir .
```

> [!IMPORTANT]
> Run `dbt debug` before anything else to confirm that dbt can locate the profile and connect to DuckDB. Fix any reported issues before proceeding.

### Step 3 — Install dbt packages

```bash
dbt deps --profiles-dir .
```

### Step 4 — Generate synthetic data

```bash
# Option A: Run the Jupyter Notebook interactively
jupyter notebook data_factory_init.ipynb

# Option B: Execute non-interactively
jupyter nbconvert --to notebook --execute data_factory_init.ipynb
```

This generates:
- `seeds/raw_customers.csv` — 1,000 customers
- `seeds/raw_products.csv` — 50 products
- `seeds/raw_orders.csv` — 2,000 orders
- `seeds/raw_shipments.csv` — ~1,500 shipments
- `data/modelflow.duckdb` — DuckDB database with bronze tables

### Step 5 — Load seeds into DuckDB

```bash
dbt seed --profiles-dir .
```

### Step 6 — Choose your interaction mode

This repository supports two modes controlled by the `DBT_MODE` environment variable:

*   **Exercise Mode (Default)**: Ignores solutions and looks at your work in the `exercise/` folders.
    ```bash
    export DBT_MODE=exercise  # or just leave it unset
    ```
*   **Solution Mode**: Uses the pre-built, correct models.
    ```bash
    export DBT_MODE=solution
    ```

> [!TIP]
> If you get stuck, use `export DBT_MODE=solution` to run the completed models and examine the reference code in the `solution/` subfolders!

### Step 7 — Run all models

```bash
# All three architectures
dbt run --profiles-dir .

# Or run a specific architecture
dbt run --select DataVault --profiles-dir .
dbt run --select Inmon3NF --profiles-dir .
dbt run --select StarSchema --profiles-dir .
```

### Step 8 — Run tests

```bash
dbt test --profiles-dir .
```

### Step 9 — Generate & browse lineage docs

```bash
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
# Open http://localhost:8080 → navigate the DAG
```

---

## 🚀 Going Further — Bonus Exercises

> These exercises are **optional** and independent from the core workshop. Complete them at your own pace once the main pipeline is running.
>
> **Solutions** are available under `snapshots/solution/`, `tests/solution/generic/`, and alongside the existing gold models. Set `export DBT_MODE=solution` to enable them.

### Bonus A — dbt Snapshots (Change Data Capture)

Implement [dbt snapshots](https://docs.getdbt.com/docs/build/snapshots) to capture historical changes over time. Create a `snapshots/` directory at the project root and build one snapshot per architecture:

| Architecture | Snapshot Target | Strategy | Unique Key | Tracking Column(s) |
|---|---|---|---|---|
| **Data Vault** | `sat_customer_details` | `check` | `hk_customer` | `cust_name`, `cust_email`, `cust_country`, `cust_city`, `cust_segment` |
| **Inmon 3NF** | `dim_customer_3nf` | `timestamp` | `cust_id` | `updated_at` |
| **Star Schema** | `dim_customer_scd2` | `timestamp` | `customer_sk` | `valid_from` |

**Steps:**
1. Create a snapshot SQL file for each architecture under `snapshots/`.
2. Modify one or more rows in the seed CSV (e.g., update a customer's email).
3. Re-run `dbt seed --profiles-dir .` followed by `dbt snapshot --profiles-dir .`.
4. Query the snapshot table to observe the historical record with `dbt_valid_from` / `dbt_valid_to` columns.

> Reference solutions: `snapshots/solution/snap_dv_sat_customer.sql`, `snap_inmon_dim_customer.sql`, `snap_ss_dim_customer.sql`

### Bonus B — Custom Generic Tests

Write [custom generic tests](https://docs.getdbt.com/docs/build/data-tests#generic-data-tests) under `tests/generic/` to enforce business rules specific to each methodology:

| Architecture | Test Name | What it Validates |
|---|---|---|
| **Data Vault** | `test_hash_key_determinism` | Recomputing a hash key on the same business key input always yields the same stored hash value |
| **Data Vault** | `test_satellite_no_duplicate_load` | A satellite never has two records sharing the same hash key and load date |
| **Inmon 3NF** | `test_no_transitive_dependency` | A fact table does not contain descriptive attributes that belong to a dimension |
| **Star Schema** | `test_scd2_no_gap_no_overlap` | SCD2 dimension rows have continuous, non-overlapping `[valid_from, valid_to)` ranges |

**Steps:**
1. Create the `tests/generic/` directory.
2. Implement each test as a reusable Jinja macro (e.g., `{% test my_test(model, column_name, ...) %}`).
3. Reference the tests in the relevant `schema.yml` files.
4. Run `dbt test --profiles-dir .` and verify all tests pass.

> Reference solutions: `tests/solution/generic/test_hash_key_determinism.sql`, `test_satellite_no_duplicate_load.sql`, `test_no_transitive_dependency.sql`, `test_scd2_no_gap_no_overlap.sql`

### Bonus C — Python Models

Implement [dbt Python models](https://docs.getdbt.com/docs/build/python-models) to add analytical capabilities that are impractical in pure SQL. Create one Python model per architecture in the `gold/` layer:

| Architecture | Model | Use Case | Why Python? |
|---|---|---|---|
| **Data Vault** | `py_bv_customer_rfm.py` | RFM customer segmentation | Percentile-based binning (`pd.qcut`) across multiple metrics |
| **Inmon 3NF** | `py_rpt_customer_ltv.py` | Customer Lifetime Value | Purchase frequency projection + quantile-based tier assignment |
| **Star Schema** | `py_mart_sales_anomaly.py` | Monthly revenue anomaly detection | Rolling statistics with conditional flagging across category partitions |

**Steps:**
1. Create a `.py` file in the relevant `python_models/` directory (e.g., `models/DataVault/solution/python_models/`).
2. Define a `model(dbt, session)` function that reads upstream models via `dbt.ref()` and returns a pandas DataFrame.
3. Set `dbt.config(materialized="table", schema="<target_schema>")` inside the function.
4. Run `dbt run --select <model_name> --profiles-dir .` and verify the output table.

> Reference solutions: `models/DataVault/solution/python_models/py_bv_customer_rfm.py`, `models/Inmon3NF/solution/python_models/py_rpt_customer_ltv.py`, `models/StarSchema/solution/python_models/py_mart_sales_anomaly.py`

> **⚠️ Important note on SQL vs. Python in dbt:**
> dbt is fundamentally designed around SQL, and **SQL should remain your default choice** for data transformations. It is more performant, simpler to test, and natively understood by the dbt DAG. Python models should only be considered when a transformation **genuinely requires** capabilities that SQL lacks — such as statistical analysis with rolling windows, machine learning, complex conditional binning (e.g., percentile-based scoring), or calling external libraries. If a transformation can be expressed clearly in SQL, prefer SQL.

---

## 📖 Essential Reading

- **[Results Viewer](modeling_results_viewer.ipynb)**: Data previews and interactive ERDs.
- **[Workshop Walkthrough](modeling_walkthrough.md)**: A summary of everything built and verified.

## 📁 Project Structure

```
ModelFlow/
├── data/                           # DuckDB database files
│   └── modelflow.duckdb
├── seeds/                          # Raw CSV seed files
│   ├── raw_customers.csv
│   ├── raw_products.csv
│   ├── raw_orders.csv
│   ├── raw_shipments.csv
│   └── schema.yml
├── macros/                         # Shared dbt macros
│   ├── hash_key.sql               # MD5 hash key for Data Vault
│   ├── hash_diff.sql              # Hash diff for satellite change detection
│   ├── load_date.sql              # DV load date timestamp
│   └── generate_surrogate_key.sql # Star Schema surrogate keys
├── models/
│   ├── DataVault/
│   │   ├── bronze/          ← staging with hash keys (hk_customer, hk_product, hk_order)
│   │   ├── silver/          ← Hubs, Links, Satellites (Raw Vault)
│   │   ├── gold/            ← Business Vault views (assembled, point-in-time)
│   │   └── python_models/   ← Bonus C: Python models (RFM segmentation)
│   ├── Inmon3NF/
│   │   ├── bronze/          ← cleansed staging, no hash keys
│   │   ├── silver/          ← 3NF CDW entities (dim_customer, dim_product, fact_order)
│   │   ├── gold/            ← pre-aggregated reporting tables
│   │   └── python_models/   ← Bonus C: Python models (CLV analysis)
│   └── StarSchema/
│       ├── bronze/          ← staging with denormalized unit price/cost
│       ├── silver/          ← SCD2 dims, date dim, fact_sales with surrogate keys
│       ├── gold/            ← fully-denormalized BI marts
│       └── python_models/   ← Bonus C: Python models (anomaly detection)
├── tests/                          # Singular dbt tests
│   ├── assert_no_orphan_orders_dv.sql
│   ├── assert_3nf_referential_integrity.sql
│   ├── assert_star_fact_no_orphan_keys.sql
│   └── generic/                   # Bonus B: custom generic tests
├── snapshots/                      # Bonus A: dbt snapshots (CDC)
├── data_factory_init.ipynb         # Synthetic data generation notebook
├── dbt_project.yml
├── profiles.yml                    # DuckDB profile (use --profiles-dir .)
├── packages.yml
└── pyproject.toml                  # uv/Python dependencies
```

---

## 🔬 Methodology Comparison

| Aspect | Data Vault 2.0 | Inmon 3NF | Star Schema |
|---|---|---|---|
| **Primary Key** | MD5 Hash Key | Natural Key | Surrogate Key |
| **History** | Satellites (append-only) | Updated in-place | SCD Type 2 |
| **Referential Integrity** | Soft (hash-validated) | Hard (FK tests) | Surrogate FK tests |
| **Query Complexity** | High (join Hub+Link+Sat) | Medium (entity joins) | Low (pre-joined marts) |
| **Flexibility** | Very High (hub-spoke) | Medium | Low (fixed star) |
| **Audit Trail** | Built-in (load_date) | External | External |
| **BI Readiness** | Low (requires BV layer) | Medium | High |
| **Best For** | Enterprise EDW, audit | Operational systems | BI/Analytics |

---

## 🧪 Test Suite

| Test Type | Architecture | File | What it Validates |
|---|---|---|---|
| Generic (not_null, unique) | All | `*/schema.yml` | Column-level constraints |
| `relationships` | DV Silver | `silver/schema.yml` | Link→Hub hash key integrity |
| `relationships` | 3NF Silver | `silver/schema.yml` | Fact→Dim hard FK constraints |
| `relationships` | SS Silver | `silver/schema.yml` | Fact→Dim surrogate key integrity |
| Singular | Data Vault | `assert_no_orphan_orders_dv.sql` | No orphan link orders |
| Singular | Inmon 3NF | `assert_3nf_referential_integrity.sql` | No orphan natural FKs |
| Singular | Star Schema | `assert_star_fact_no_orphan_keys.sql` | No orphan surrogate keys |

---

## 🛠️ DuckDB Schemas Created

| Schema | Architecture | Layer | Content |
|---|---|---|---|
| `raw` | All | Seed | Raw CSV data loaded by `dbt seed` |
| `dv_bronze` | DataVault | Bronze | Staging views with hash keys |
| `dv_silver` | DataVault | Silver | Hubs, Links, Satellites |
| `dv_gold` | DataVault | Gold | Business Vault views |
| `inmon_bronze` | Inmon3NF | Bronze | Staging views |
| `inmon_silver` | Inmon3NF | Silver | 3NF CDW entities |
| `inmon_gold` | Inmon3NF | Gold | Reporting aggregations |
| `ss_bronze` | StarSchema | Bronze | Staging views |
| `ss_silver` | StarSchema | Silver | SCD2 dims + Fact |
| `ss_gold` | StarSchema | Gold | BI Marts |

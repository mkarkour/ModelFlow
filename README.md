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

## ⚡ Quick Start

### 1. Install dependencies (using `uv`)

```bash
cd ModelFlow

# Create virtual environment and install all Python deps
uv sync

# Activate the environment
source .venv/bin/activate
```

### 🎯 Workshop Interaction Modes

This repository supports two modes. You can switch between them using the `DBT_MODE` environment variable:

*   **Exercise Mode (Default)**: Ignores solutions and looks at your work in the `exercise/` folders.
    ```bash
    export DBT_MODE=exercise  # or just leave it unset
    dbt run
    ```
*   **Solution Mode**: Uses the pre-built, correct models.
    ```bash
    export DBT_MODE=solution
    dbt run
    ```

> [!TIP]
> If you get stuck, use `export DBT_MODE=solution` to run the completed models and examine the reference code in the `solution/` subfolders!

### 2. Generate synthetic data

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

### 3. Install dbt packages

```bash
dbt deps --profiles-dir .
```

### 4. Load seeds into DuckDB

```bash
dbt seed --profiles-dir .
```

### 5. Run all models

```bash
# All three architectures
dbt run --profiles-dir .

# Or run a specific architecture
dbt run --select DataVault --profiles-dir .
dbt run --select Inmon3NF --profiles-dir .
dbt run --select StarSchema --profiles-dir .
```

### 6. Run tests

```bash
dbt test --profiles-dir .
```

### 7. Generate & browse lineage docs

```bash
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
# Open http://localhost:8080 → navigate to the DAG
```

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
│   │   ├── bronze/  ← staging with hash keys (hk_customer, hk_product, hk_order)
│   │   ├── silver/  ← Hubs, Links, Satellites (Raw Vault)
│   │   └── gold/    ← Business Vault views (assembled, point-in-time)
│   ├── Inmon3NF/
│   │   ├── bronze/  ← cleansed staging, no hash keys
│   │   ├── silver/  ← 3NF CDW entities (dim_customer, dim_product, fact_order)
│   │   └── gold/    ← pre-aggregated reporting tables
│   └── StarSchema/
│       ├── bronze/  ← staging with denormalized unit price/cost
│       ├── silver/  ← SCD2 dims, date dim, fact_sales with surrogate keys
│       └── gold/    ← fully-denormalized BI marts
├── tests/                          # Singular dbt tests
│   ├── assert_no_orphan_orders_dv.sql
│   ├── assert_3nf_referential_integrity.sql
│   └── assert_star_fact_no_orphan_keys.sql
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

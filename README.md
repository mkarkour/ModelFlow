# ModelFlow — Multi-Architecture Data Modeling Workshop

> **dbt + DuckDB** · Data Vault 2.0 · Inmon 3NF · Star Schema

A comprehensive data engineering workspace demonstrating **three parallel modeling methodologies** on a shared e-commerce dataset using a Bronze → Silver → Gold medallion architecture.

---

## Architecture Overview

```
seeds/ (raw_customers, raw_products, raw_orders, raw_shipments)
    └──► Bronze (Views): Staging & Hash Key computation
             └──► Silver (Tables): Core modeling per methodology
                      └──► Gold (Tables): Business-ready outputs

Three parallel paths from the same Bronze source:
  ├── DataVault/  → Hubs + Links + Satellites     → Business Vault
  │                  *(Note: frameworks like datavault4dbt and automateDV can be used on enterprise backends, but do not support DuckDB)*
  ├── Inmon3NF/   → 3NF Entities → CDW Fact       → Reporting Aggregations
  └── StarSchema/ → SCD2 Dims + Date → Fact Sales → BI Marts

Each architecture has two subfolders controlled by DBT_MODE:
  ├── exercise/   ← your work goes here  (DBT_MODE=exercise, default)
  └── solution/   ← reference implementation  (DBT_MODE=solution)
```

---

## Prerequisites

Ensure the following tools are installed before proceeding:

| Tool | Minimum Version | Purpose |
|---|---|---|
| [Git](https://git-scm.com/) | 2.x | Clone the repository |
| [Python](https://www.python.org/) | 3.11+ | Runtime for dbt and data generation |
| [uv](https://docs.astral.sh/uv/) | latest | Python package & environment manager |

---

## Quick Start

### Step 0 — Clone the repository

```bash
git clone git@code.euranova.eu:data-modeling-workshop/modelflow.git
cd ModelFlow
```

### Step 1 — Create the virtual environment and install dependencies

```bash
uv sync

source .venv/bin/activate
```

### Step 2 — Generate synthetic data

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

### Step 3 — Verify the dbt connection

```bash
dbt debug --profiles-dir .
```

> [!IMPORTANT]
> Run `dbt debug` before anything else to confirm that dbt can locate the profile and connect to DuckDB. Fix any reported issues before proceeding.

> [!NOTE]
> **Why the `--profiles-dir .` flag?**
> By default, dbt looks for connection settings in your global `~/.dbt/` folder. This flag forces dbt to use the **local `profiles.yml`** located in this project's root directory. 
> 
> This setup ensures:
> * **Portability:** Seamless connection to the local DuckDB database (`data/modelflow.duckdb`) without manual configuration.
> * **Isolation:** Workshop settings won't interfere with your other dbt projects.
> * **Consistency:** Everyone uses the exact same connection logic regardless of their local machine setup.

### Step 4 — Install dbt packages

```bash
dbt deps --profiles-dir .
```


### Step 5 — Load seeds into DuckDB

```bash
dbt seed --profiles-dir .
```

### Step 6 — Choose your interaction mode

This repository supports two modes controlled by the `DBT_MODE` environment variable:

- **Exercise Mode (Default)**: Runs models from `exercise/` subfolders — your code.
    ```bash
    export DBT_MODE=exercise  # or just leave it unset
    ```
- **Solution Mode**: Runs models from `solution/` subfolders — the reference implementation.
    ```bash
    export DBT_MODE=solution
    ```

Verify the active mode at any time:
```bash
echo ${DBT_MODE:-exercise} 
```
or

```bash
dbt run-operation check_mode --profiles-dir .
```

> [!TIP]
> If you get stuck, use `export DBT_MODE=solution` to run the completed models and examine the reference code in the `solution/` subfolders!

---

## Workshop Iteration Loop

Once the environment is running (Steps 0–6 above), every modeling exercise follows the same four-step loop:

### 1. Open the exercise file

All your work lives in the `exercise/` subfolder of the relevant architecture and layer. Navigate to the model you are working on:

```
models/
  DataVault/exercise/bronze/    ← start here for Data Vault
  DataVault/exercise/silver/
  DataVault/exercise/gold/
  Inmon3NF/exercise/bronze/     ← start here for Inmon 3NF
  Inmon3NF/exercise/silver/
  Inmon3NF/exercise/gold/
  StarSchema/exercise/bronze/   ← start here for Star Schema
  StarSchema/exercise/silver/
  StarSchema/exercise/gold/
```

Each file contains hints and the expected output columns in comments. Read them carefully before writing any SQL.

### 2. Write your SQL

Fill in the transformation logic inside the file. Follow the layer conventions:

- **Bronze** — staging only: cast types, trim strings, compute hash keys (Data Vault) or `unit_price`/`unit_cost` (Star Schema). No business logic.
- **Silver** — core modeling: Hubs/Links/Satellites, 3NF entities, or SCD2 dimensions and facts.
- **Gold** — business-ready outputs: assembled views, pre-aggregated reports, or fully denormalized BI marts.

### 3. Build and test the model

Run only the model you just wrote, then its tests:

```bash
# Build a single model (run + test in one command)
dbt build --select <model_name> --profiles-dir .

# Or separately
dbt run  --select <model_name> --profiles-dir .
dbt test --select <model_name> --profiles-dir .
```

To build an entire layer at once:

```bash
dbt build --select DataVault.exercise.silver --profiles-dir .
```

To build a model **and all its upstream dependencies**:

```bash
dbt build --select +<model_name> --profiles-dir .
```

> [!TIP]
> Use `dbt build` rather than `dbt run` during exercises — it runs the model **and** its schema tests in a single command, so you get immediate feedback on constraints (not_null, unique, relationships).

### 4. Inspect the results

Open the Results Viewer notebook to preview the data produced by your model and compare it against the expected ERD:

```bash
jupyter notebook models/modeling_results_viewer.ipynb
```

Run the cell for the model you just built. If the output looks correct, move on to the next model in the layer. If something is off, go back to step 2.

> [!NOTE]
> Work through each architecture **layer by layer** (Bronze → Silver → Gold). Downstream models depend on upstream ones, so build them in order.

---

### Step 7 — Generate & browse lineage docs

```bash
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
# Open http://localhost:8080 → navigate the DAG
```

---

## Going Further — Bonus Exercises

> These exercises are **optional** and independent from the core workshop. Complete them at your own pace once the main pipeline is running.
>
> **Solutions** are available under `snapshots/<Architecture>/solution/`, `tests/solution/generic/`, and alongside the existing gold models. Set `export DBT_MODE=solution` to enable them.

### Bonus A — dbt Snapshots (Change Data Capture)

Implement [dbt snapshots](https://docs.getdbt.com/docs/build/snapshots) to capture historical changes over time. Write your snapshots in the `exercise/` subfolders under `snapshots/`:

| Architecture | Snapshot File | Strategy | Unique Key | Tracking Column(s) |
|---|---|---|---|---|
| **Data Vault** | `snapshots/DataVault/exercise/snap_dv_sat_customer.sql` | `check` | `hk_customer` | `cust_name`, `cust_email`, `cust_country`, `cust_city`, `cust_segment` |
| **Inmon 3NF** | `snapshots/Inmon3NF/exercise/snap_inmon_dim_customer.sql` | `timestamp` | `cust_id` | `updated_at` |
| **Star Schema** | `snapshots/StarSchema/exercise/snap_ss_dim_customer.sql` | `timestamp` | `customer_sk` | `valid_from` |

**Steps:**
1. Fill in the snapshot SQL file for each architecture in the `exercise/` folder.
2. Modify one or more rows in the seed CSV (e.g., update a customer's email).
3. Re-run `dbt seed --profiles-dir .` followed by `dbt snapshot --profiles-dir .`.
4. Query the snapshot table to observe the historical record with `dbt_valid_from` / `dbt_valid_to` columns.

> Reference solutions: `snapshots/DataVault/solution/snap_dv_sat_customer.sql`, `snapshots/Inmon3NF/solution/snap_inmon_dim_customer.sql`, `snapshots/StarSchema/solution/snap_ss_dim_customer.sql`

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

Implement [dbt Python models](https://docs.getdbt.com/docs/build/python-models) to add analytical capabilities that are impractical in pure SQL. Write your Python models in the `python_models/` folder of the relevant architecture's `exercise/` directory:

| Architecture | Model | Use Case | Why Python? |
|---|---|---|---|
| **Data Vault** | `models/DataVault/exercise/python_models/py_bv_customer_rfm.py` | RFM customer segmentation | Percentile-based binning (`pd.qcut`) across multiple metrics |
| **Inmon 3NF** | `models/Inmon3NF/exercise/python_models/py_rpt_customer_ltv.py` | Customer Lifetime Value | Purchase frequency projection + quantile-based tier assignment |
| **Star Schema** | `models/StarSchema/exercise/python_models/py_mart_sales_anomaly.py` | Monthly revenue anomaly detection | Rolling statistics with conditional flagging across category partitions |

**Steps:**
1. Fill in the `.py` file in the relevant `exercise/python_models/` directory.
2. Define a `model(dbt, session)` function that reads upstream models via `dbt.ref()` and returns a pandas DataFrame.
3. Set `dbt.config(materialized="table", schema="<target_schema>")` inside the function.
4. Run `dbt run --select <model_name> --profiles-dir .` and verify the output table.

> Reference solutions: `models/DataVault/solution/python_models/py_bv_customer_rfm.py`, `models/Inmon3NF/solution/python_models/py_rpt_customer_ltv.py`, `models/StarSchema/solution/python_models/py_mart_sales_anomaly.py`

> **Important note on SQL vs. Python in dbt:**
> dbt is fundamentally designed around SQL, and **SQL should remain your default choice** for data transformations. It is more performant, simpler to test, and natively understood by the dbt DAG. Python models should only be considered when a transformation **genuinely requires** capabilities that SQL lacks — such as statistical analysis with rolling windows, machine learning, complex conditional binning (e.g., percentile-based scoring), or calling external libraries. If a transformation can be expressed clearly in SQL, prefer SQL.

---

## Essential Reading

- **[dbt Cheatsheet](dbt_cheatsheet.md)**: Quick reference for dbt commands and project structure concepts.
- **[Results Viewer](models/modeling_results_viewer.ipynb)**: Data previews and interactive ERDs.
- **[Workshop Walkthrough](modeling_walkthrough.md)**: A summary of everything built and verified.

## Project Structure

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
│   └── check_mode.sql             # Log the active DBT_MODE
├── models/
│   ├── DataVault/
│   │   ├── exercise/              ← your work (DBT_MODE=exercise, default)
│   │   │   ├── bronze/            ← staging with hash keys (hk_customer, hk_product, hk_order)
│   │   │   ├── silver/            ← Hubs, Links, Satellites (Raw Vault)
│   │   │   ├── gold/              ← Business Vault views (assembled, point-in-time)
│   │   │   └── python_models/    ← Bonus C: RFM segmentation
│   │   └── solution/              ← reference implementation (DBT_MODE=solution)
│   │       ├── bronze/
│   │       ├── silver/
│   │       ├── gold/
│   │       └── python_models/
│   ├── Inmon3NF/
│   │   ├── exercise/              ← your work
│   │   │   ├── bronze/            ← cleansed staging, no hash keys
│   │   │   ├── silver/            ← 3NF CDW entities (dim_customer, dim_product, fact_order)
│   │   │   ├── gold/              ← pre-aggregated reporting tables
│   │   │   └── python_models/    ← Bonus C: CLV analysis
│   │   └── solution/              ← reference implementation
│   │       ├── bronze/
│   │       ├── silver/
│   │       ├── gold/
│   │       └── python_models/
│   └── StarSchema/
│       ├── exercise/              ← your work
│       │   ├── bronze/            ← staging with denormalized unit price/cost
│       │   ├── silver/            ← SCD2 dims, date dim, fact_sales with surrogate keys
│       │   ├── gold/              ← fully-denormalized BI marts
│       │   └── python_models/    ← Bonus C: anomaly detection
│       └── solution/              ← reference implementation
│           ├── bronze/
│           ├── silver/
│           ├── gold/
│           └── python_models/
├── snapshots/                      # Bonus A: dbt snapshots (CDC)
│   ├── DataVault/
│   │   ├── exercise/snap_dv_sat_customer.sql
│   │   └── solution/snap_dv_sat_customer.sql
│   ├── Inmon3NF/
│   │   ├── exercise/snap_inmon_dim_customer.sql
│   │   └── solution/snap_inmon_dim_customer.sql
│   └── StarSchema/
│       ├── exercise/snap_ss_dim_customer.sql
│       └── solution/snap_ss_dim_customer.sql
├── tests/                          # dbt data tests
│   ├── exercise/                   ← your work
│   │   └── generic/                
│   │       ├── test_custom_check.sql
│   │       ├── assert_custom_test.sql
│   │       └── tests.yml
│   └── solution/                  # Singular & generic reference tests
│       ├── assert_no_orphan_orders_dv.sql
│       ├── assert_3nf_referential_integrity.sql
│       ├── assert_star_fact_no_orphan_keys.sql
│       └── generic/               # Bonus B: custom generic tests
│           ├── test_hash_key_determinism.sql
│           ├── test_satellite_no_duplicate_load.sql
│           ├── test_no_transitive_dependency.sql
│           └── test_scd2_no_gap_no_overlap.sql
├── data_factory_init.ipynb         # Synthetic data generation notebook
├── dbt_cheatsheet.md               # Quick dbt command reference
├── dbt_project.yml
├── profiles.yml                    # DuckDB profile (use --profiles-dir .)
├── packages.yml
└── pyproject.toml                  # uv/Python dependencies
```

---

## Methodology Comparison

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

## Test Suite

| Test Type | Architecture | Location | What it Validates |
|---|---|---|---|
| Generic (not_null, unique) | All | `*/schema.yml` | Column-level constraints |
| `relationships` | DV Silver | `exercise/silver/schema.yml` | Link→Hub hash key integrity |
| `relationships` | 3NF Silver | `exercise/silver/schema.yml` | Fact→Dim hard FK constraints |
| `relationships` | SS Silver | `exercise/silver/schema.yml` | Fact→Dim surrogate key integrity |
| Singular | Data Vault | `tests/solution/assert_no_orphan_orders_dv.sql` | No orphan link orders |
| Singular | Inmon 3NF | `tests/solution/assert_3nf_referential_integrity.sql` | No orphan natural FKs |
| Singular | Star Schema | `tests/solution/assert_star_fact_no_orphan_keys.sql` | No orphan surrogate keys |

---

## DuckDB Schemas Created

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

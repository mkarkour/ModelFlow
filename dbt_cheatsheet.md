# dbt (Data Build Tool) Cheatsheet

This cheatsheet covers essential dbt commands and provides an overview of the standard dbt project structure, as well as the best practices to follow, to help you get started with data modeling and dbt.

---
## 💡 What is Data Build Tool (dbt)

`dbt` is a centralized development framework that enables data teams to transform data within their warehouses by applying software engineering best practices to the SQL workflow. Its core value proposition is built upon four foundational pillars:

* **Modularity**: `dbt` facilitates the creation of a modular data architecture by allowing developers to break down complex logic into discrete, reusable models. Using the `ref()` function, `dbt` automatically manages dependencies and builds a Directed Acyclic Graph (DAG), ensuring that data is processed in the correct order while minimizing code redundancy.

* **Dynamic Documentation**: Documentation is treated as a first-class citizen within `dbt`. By utilizing `.yml` files as a foundational configuration layer, `dbt` generates rich, web-based documentation that includes descriptions, column-level metadata, and visual data lineage. This ensures that the data warehouse remains transparent, governed, and easily discoverable for all stakeholders.

* **Testing**: `dbt` provides a robust framework for automated data validation. It supports both singular tests—bespoke SQL queries designed to catch complex business logic failures—and generic tests, which are reusable macros (such as unique, not_null, or accepted_values) applied directly to columns to ensure continuous data quality and integrity.

* **Engineering Capabilities**: `dbt` bridges the gap between data analysis and software engineering by integrating essential dev-ops capabilities into the data pipeline. This includes support for version control, CI/CD integration, automated code formatting and linting, and more to maintain rigorous coding standards.

---

## 🛠️ Core dbt Commands

### Project Setup & Verification

**`dbt init`**
Scaffolds a new dbt project by creating the standard folder structure (`models/`, `seeds/`, `tests/`, etc.) and prompting you to configure your data warehouse connection. Run this once when starting a new project.

**`dbt debug`**
Validates that your `profiles.yml` connection settings are correct and that dbt can reach your data warehouse. Run this first when setting up a new environment or troubleshooting connection issues.

**`dbt deps`**
Downloads and installs all external packages listed in your `packages.yml` file (e.g., `dbt-utils`, `dbt-expectations`). Run this after cloning a project or adding a new package dependency.

---

### Execution & Compilation
**`dbt run`**
Executes your dbt models: compiles each `.sql` file into warehouse-ready SQL and runs it, materializing the results as tables or views in your data warehouse. By default, runs all models. Use selectors to target specific ones:
```bash
dbt run --select staging        # run all models in the staging folder
dbt run --select my_model+      # run my_model and all its downstream dependents
dbt run --select +my_model      # run my_model and all its upstream dependencies
```

**`dbt compile`**
Compiles your Jinja-templated SQL models into pure SQL and writes them to the `target/compiled/` folder — without executing anything in the warehouse. Use this to preview the SQL dbt will generate, debug Jinja logic, or inspect `ref()` resolutions before a run.

**`dbt build`**
The recommended command for production runs. Executes the full pipeline in dependency order: seeds → snapshots → models → tests. If a model fails its tests, downstream models are automatically skipped. This is the single command that handles everything.

**`dbt run-operation <macro_name>`**
Calls a Jinja macro directly from the command line, outside the context of a model run. Useful for running admin tasks, warehouse operations, or utility macros (e.g., dropping schemas, granting permissions).
```bash
dbt run-operation grant_access --args '{"role": "analyst"}'
```

---

### Testing & Quality

**`dbt test`**
Runs all tests defined in your project — both schema tests declared in `.yml` files (e.g., `not_null`, `unique`, `accepted_values`, `relationships`) and custom SQL tests in the `tests/` folder. A test fails if the SQL query returns any rows.
```bash
dbt test --select my_model      # test a specific model only
dbt test --store-failures       # persist failing rows to the warehouse for inspection
```

---

### Data Loading & State Management
**`dbt seed`**
Reads CSV files from the `seeds/` directory and loads them as tables into your data warehouse. Designed for small, static reference datasets like country codes, currency mappings, or status lookup tables. Not intended for large or frequently changing data.

**`dbt snapshot`**
Runs your snapshot definitions to capture row-level changes in source tables over time. Each execution compares the current state of a source table against the previously recorded state and stamps rows with `dbt_valid_from` / `dbt_valid_to` timestamps. This is dbt's built-in mechanism for building **Type 2 Slowly Changing Dimensions (SCD2)**.

---

### Documentation

**`dbt docs generate`**
Reads your model definitions, schema `.yml` files, and run artifacts to generate a static documentation site in the `target/` folder. The site includes a full data lineage graph (DAG) showing how models depend on each other.

**`dbt docs serve`**
Launches a local web server (at `http://localhost:8080` by default) to browse the generated documentation in your browser. Requires `dbt docs generate` to have been run first.

---

## 📁 Standard dbt Project Structure

Running `dbt init` produces this layout. Each directory has a specific role — understanding them helps you know where to put your work.

```
my_dbt_project/
├── models/
│   ├── examples/       ← example models with 2 models & a schema yml file
├── seeds/
├── tests/
├── macros/
├── snapshots/
├── analyses/
├── target/             ← auto-generated, gitignored
├── dbt_project.yml
└── packages.yml
```

---

### Key Directories
* **`models/`**: The core of your project. This is where your SQL (or Python) transformation files live. Models are typically organized into subfolders like `staging` (raw data preparation), `intermediate` (reusable logical blocks), and `marts` (business-ready data).
* **`seeds/`**: This directory holds raw CSV files containing static data (e.g., country codes, mapping tables). Running `dbt seed` loads these files directly into your data warehouse as tables.
* **`tests/`**: Contains custom data tests. While singular tests (like checking if a column is unique or not null) are often defined in `.yml` files, custom SQL queries used to validate your business logic go here.
* **`macros/`**: The home for your reusable code blocks written in Jinja. Macros function similarly to functions in traditional programming, allowing you to write complex logic once and apply it across multiple models.
* **`snapshots/`**: Contains SQL definitions for capturing the state of mutable data over time. This is dbt's way of building Type 2 Slowly Changing Dimensions (SCDs).
* **`analyses/`**: Stores analytical SQL queries that you want dbt to compile (so you can use Jinja and references) but *not* execute or materialize in the data warehouse. Useful for ad-hoc analysis or training models.
* **`target/`**: An auto-generated directory (ignored by version control) where dbt outputs compiled SQL files and execution artifacts (like `run_results.json` and `manifest.json`) when you run commands.

---

### Key Configuration Files

**`dbt_project.yml`**
The main configuration file for your project. Defines the project name, dbt version, folder paths, and default materialization strategies per model folder (e.g., "all models in `staging/` should be views; all models in `marts/` should be tables"). Every dbt project must have this file.

**`packages.yml`** *(optional)*
Lists external dbt package dependencies, similar to a `requirements.txt`. Packages are pulled from the dbt Hub or directly from Git. Run `dbt deps` after adding or updating entries here. (This file could also be called `dependencies.yml`)
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

**`profiles.yml`** *(stored locally, never committed)*
Contains your warehouse connection credentials and target environments (`dev`, `prod`). Lives at `~/.dbt/profiles.yml` on your local machine — outside the project repo — so credentials are never accidentally committed to version control. Each named profile maps to a warehouse type (Snowflake, BigQuery, Redshift, etc.) and its connection parameters.

---

##  ✅ Best Practices

To fully **harness** dbt's capabilities, certain best practices should be followed. These patterns ensure that your code, and your data models more generally, remain **readable**, **maintainable**, and **easy for teammates to debug** (remember: **Code is Empathy**).

### The CTE-First Transformation Pattern

Avoid deeply nested subqueries. Instead, use Common Table Expressions (CTEs) to break your logic into a linear, "story-telling" flow. A standard dbt model should follow this structure:

* **Import CTEs**: Select from `ref()` or `source()` at the very top. This makes dependencies clear.

* **Logical CTEs**: Perform specific transformations (renaming, casting, filtering) in dedicated blocks.

* **Final CTE**: The last block that assembles everything.

* **Final Select**: A simple `select * from final` makes it easy to debug any intermediate step by changing the CTE name in the final select.

```sql
with orders as (
    select * from {{ ref('stg_orders') }}
),

-- Perform specific logic in a named block
filtered_orders as (
    select * from orders where status = 'completed'
),

final as (
    select 
        order_id,
        order_date,
        ...
    from filtered_orders
)

select * from final
```

### Ref and Source Macros

Never use hardcoded table names: Always use `{{ ref('model_name') }}` for internal models and `{{ source('source_name', 'table_name') }}` for raw data.


> [!NOTE]
> **Why?** This is how dbt builds the **Directed Acyclic Graph (DAG)** and determines the correct execution order.

### Modularize Your Logic
* **Don't build "Mega-Models"**: If a model is 500 lines long, break it into smaller Intermediate models.

* **DRY (Don't Repeat Yourself)**: If you find yourself writing the same complex CASE statement in five different models, move that logic into a Macro.

### Naming & Organization

Generally, dbt projects adhere to the [Medaillon Architecture](https://www.databricks.com/blog/what-is-medallion-architecture)  convention. This means your models/ directory should be organized into three distinct sub-layers: **Bronze**, **Silver**, and **Gold**. In most dbt implementations, these layers are mapped as **Staging** (Bronze), **Intermediate** (Silver), and **Marts** (Gold). Consequently, models within these directories should follow a strict naming convention to maintain clarity:

* `STG_`: Prefix for staging models (used for cleaning, casting, and renaming raw data).

* `INT_`: Prefix for intermediate models (used for complex joins and reusable business logic).

* `FCT_ / DIM_`: Prefixes for the final Star Schema layers—Fact and Dimension tables—found in the Marts.

* `UPPER_SNAKE_CASE`: All file names, column names, and aliases must use uppercase snake_case (e.g., STG_ORDERS, DIM_CUSTOMERS).


### Document & Schema Management

Within the dbt framework, `.yml` files serve as the foundational configuration layer for your documentation. Beyond simple descriptions, these files are the primary mechanism for configuring data tests, defining source freshness, and setting up model properties. They transform raw SQL into a governed and discoverable data asset. 

* **Standard Layer Configuration**: A dedicated `.yml` file must be provided for every layer (Staging, Intermediate, Marts) following this standard structure:

```yaml
version: 2

models:
  - name: STG_CUSTOMERS
    description: "Standardized customer records containing contact information and segments."
    config:
      tags: "customer"
    data_tests:
      - dbt_utils.expression_is_true:
          expression: "CREATED_AT <= UPDATED_AT"

    columns:
      - name: CUST_ID
        description: "The primary business key for the customer."
        data_type: INTEGER
        data_tests:
          - unique
          - not_null

      - name: CUST_EMAIL
        description: "The sanitized, lowercase email address of the customer."
        data_type: STRING
```

> [!TIP]
> **Schema Fragmentation**: If a directory contains an extensive number of models, do not rely on a single, oversized schema.yml file. Instead, fragment the documentation by creating individual .yml files for each specific model. To ensure project consistency, adopt one of the following three naming conventions:
> * MODEL_NAME.yml (e.g., STG_CUSTOMERS.yml)
> * model_name.yml (e.g., stg_customers.yml) (Highly recommended for perfect symmetry with your SQL files)
> * _model_name_.yml (e.g., _stg_customers.yml)


* **Extending Documentation beyond Models**: Within a mature dbt project, documentation should not be limited to models. Both custom macros and generic tests should be documented in `.yml` files within their respective directories (`macros/` or `tests/`). This ensures that the logic behind reusable code is transparent and that utility functions are easily discoverable via the dbt docs site.

For tests:
```yaml
version: 2

tests:
  - name: TEST_VALID_VAT_NUMBER
    description: "Validates that a string follows the standard EU VAT format (2-letter country code followed by 8-12 digits)."
    arguments:
      - name: column_name
        description: "The column containing the VAT identifier."
      - name: country_code_column
        description: "Optional column to validate specific country format rules."
  
  - name: ASSERT_NO_ORPHAN_ORDERS
    description: "Asserts that there are no orphan orders."
```

For Macros:
```yaml
version: 2

macros:
  - name: CALCULATE_GROSS_REVENUE
    description: "Computes the revenue after discounts but before taxes."
    arguments:
      - name: quantity
        description: "The number of units sold."
      - name: unit_price
        description: "The list price per unit."
      - name: discount_pct
        description: "The percentage discount applied (0-100)."
```

### Tests & Data

The `tests/` directory is designed to house two distinct types of validation logic:

* **Singular Tests (Model-level):**
    * These are standalone `.sql` files containing a query that should return zero rows under normal conditions. If the query returns any results, the test fails.

    * **Convention:** These files must be named using the prefix `ASSERT_` followed by the test's intent (e.g., `ASSERT_TOTAL_REVENUE_IS_POSITIVE.sql` (in upper or lower case)).

    * **Scope:** Use these for complex, one-off business logic that applies to an entire model rather than a single column.

* **Generic Tests (Macro-level):**
    * Located within the `tests/generic/` sub-directory, these are reusable macros that encapsulate a specific validation logic (e.g., checking a VAT format or a date range).

    * **Scope:** Once defined, these tests can be applied to any column across multiple models directly within your `.yml` files.

    * **Benefit:** This promotes the DRY (Don't Repeat Yourself) principle by standardizing common checks throughout the project.


> [!IMPORTANT]
> **Atomic Tests:** At minimum, every primary key should have unique and not_null tests.

> [!TIP]
> **Note on Packages:** You can also leverage external packages like [dbt_utils](https://github.com/dbt-labs/dbt-utils) or [dbt_expectations](https://github.com/metaplane/dbt-expectations). These provide a vast library of pre-built tests (e.g., at_least_one, expression_is_true, or expect_column_values_to_be_between) that can be used immediately without writing custom code.

### Formatting & Linting

To ensure consistency across the entire project, we utilize automated tools to manage SQL and Python syntax and style. This removes subjective debates over code formatting and allows the team to focus on logic and performance.

* **sqlfmt** (The Formatter): 
    * We use sqlfmt as our primary opinionated formatter. It automatically reshapes your SQL into a clean, readable, and standardized format.

    * **Requirement**: All SQL files must be formatted using sqlfmt before being committed to the repo  sitory.

    * **Benefit**: Ensures that every model follows the same indentation, line breaks, and spacing, making diffs easier to read during code reviews.

* **sqlfluff** (The Linter): 
    * We utilize sqlfluff to enforce a strict set of linting rules. Unlike a formatter, a linter checks for structural issues, anti-patterns, and naming convention violations.
    * **Scope**: sqlfluff validates that models adhere to our UPPER_SNAKE_CASE requirement, identifies unused CTEs, and catches ambiguous join conditions.
    * **Enforcement**: Linting checks are typically integrated into our CI/CD pipeline; a model that fails linting will prevent a successful build.

> [!IMPORTANT]
> **Pre-Commit Discipline**: Before pushing your changes, always run sqlfmt to clean your code and sqlfluff lint to identify any rule violations. Automated formatting is the easiest way to demonstrate empathy for the person reviewing your code.

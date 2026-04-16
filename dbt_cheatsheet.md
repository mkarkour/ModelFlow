# dbt (Data Build Tool) Cheatsheet

This cheatsheet covers essential dbt commands and provides an overview of the standard dbt project structure to help you get started with data modeling.

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


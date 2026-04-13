# dbt (Data Build Tool) Cheatsheet

This cheatsheet covers essential dbt commands and provides an overview of the standard dbt project structure to help you get started with data modeling.

---

## 🛠️ Core dbt Commands

### Project Setup & Verification
**`dbt init`**: Initialises a new dbt project[cite: 3].
**`dbt debug`**: Verifies your configuration and data warehouse connection[cite: 5].
**`dbt deps`**: Installs packages listed in packages.yml[cite: 36].

### Execution & Compilation
**`dbt run`**: Executes models (transforms them into tables/views in the data warehouse)[cite: 7].
**`dbt compile`**: Compiles models into raw SQL without executing them (useful for debugging)[cite: 9].
**`dbt build`**: Does it all: run + test + snapshot + seed + freshness (recommended for prod)[cite: 18].
**`dbt run-operation <macro_name>`**: Executes a Jinja macro outside of a model[cite: 38].

### Testing & Quality
**`dbt test`**: Runs tests (built-in and custom) on your models[cite: 20].

### Data Loading & State Management
**`dbt seed`**: Loads CSV files (from the seed folder) as tables into the data warehouse[cite: 22].
**`dbt snapshot`**: Captures changes in data over time (row-level versioning)[cite: 24].

### Documentation
**`dbt docs generate`**: Generates HTML documentation for your models[cite: 32].
**`dbt docs serve`**: Serves the documentation locally in a browser (localhost:8000 by default)[cite: 34].

---

## 📁 Standard dbt Project Structure

When you initialize a dbt project, it creates a specific directory structure. Here is what each folder and key file does:

### Key Directories
* **`models/`**: The core of your project. This is where your SQL (or Python) transformation files live. Models are typically organized into subfolders like `staging` (raw data preparation), `intermediate` (reusable logical blocks), and `marts` (business-ready data).
* **`seeds/`**: This directory holds raw CSV files containing static data (e.g., country codes, mapping tables). Running `dbt seed` loads these files directly into your data warehouse as tables.
* **`tests/`**: Contains custom data tests. While singular tests (like checking if a column is unique or not null) are often defined in `.yml` files, custom SQL queries used to validate your business logic go here.
* **`macros/`**: The home for your reusable code blocks written in Jinja. Macros function similarly to functions in traditional programming, allowing you to write complex logic once and apply it across multiple models.
* **`snapshots/`**: Contains SQL definitions for capturing the state of mutable data over time. This is dbt's way of building Type 2 Slowly Changing Dimensions (SCDs).
* **`analyses/`**: Stores analytical SQL queries that you want dbt to compile (so you can use Jinja and references) but *not* execute or materialize in the data warehouse. Useful for ad-hoc analysis or training models.
* **`target/`**: An auto-generated directory (ignored by version control) where dbt outputs compiled SQL files and execution artifacts (like `run_results.json` and `manifest.json`) when you run commands.

### Key Configuration Files
* **`dbt_project.yml`**: The main configuration file for your project. It defines the project name, version, default materializations (e.g., table vs. view), and directory paths.
* **`packages.yml`** *(optional)*: Specifies dependencies on external dbt packages (like `dbt-utils` or `dbt-expectations`). 
* **`profiles.yml`**: Located locally on your machine (usually in `~/.dbt/`), this file contains the sensitive connection credentials and warehouse target environments (e.g., `dev` or `prod`).
# 🏭 Data Vault 2.0 at Scale (Enterprise Note)

While this workshop uses custom macros to implement Data Vault on DuckDB, enterprise environments (Snowflake, BigQuery, Snowflake, etc.) typically leverage robust, specialized dbt packages.

### 📦 Recommended Packages

If you are deploying Data Vault in a production environment with an Enterprise Data Warehouse (EDW), consider using:

1.  **[datavault4dbt](https://hub.getdbt.com/ScalefreeCOM/datavault4dbt/latest/)** (by Scalefree)
    *   **Focus**: Standardized Data Vault 2.0 implementation.
    *   **Features**: Provides `stage`, `hub`, `link`, and `sat` macros out of the box.
    *   **Platforms**: Optimized for BigQuery, Snowflake, and PostgreSQL.

2.  **[automate-dv](https://automate-dv.readthedocs.io/en/latest/)** (formerly dbtvault)
    *   **Focus**: Extensive automation and metadata-driven loading.
    *   **Features**: Handles complex patterns like Multi-active Satellites and PIT tables.
    *   **Platforms**: Wide support including Snowflake, BigQuery, and SQL Server.

### 🛠️ Why use a package?
*   **Maintenance**: Hashing logic and loading patterns are maintained by the community.
*   **Standardization**: Ensures consistent implementations across large teams.
*   **Automation**: Simplifies the creation of ghost records, HWM (High Water Mark) management, and multi-source hubs/links.

> [!NOTE]
> During this workshop, we use custom macros (`hash_key`, `hash_diff`) in our solutions to remain compatible with **DuckDB** while still demonstrating the core architectural principles.

---

## 📋 Workshop Metadata Standards

To successfully complete the Data Vault exercises, every table must include specific metadata. Follow these standards to ensure your models pass the automated tests.

### 1. Staging (Bronze)

The staging layer is where you prepare your data for the vault. Every staging model must compute:

| Metadata Column | Description | Macro Helper |
|:---|:---|:---|
| `hk_<entity>` | Hash Key for the primary business key. | `{{ hash_key(['column_name']) }}` |
| `hash_diff` | MD5 fingerprint of all descriptive attributes. | `{{ hash_diff(['col1', 'col2', ...]) }}` |
| `load_date` | The timestamp when the record enters the warehouse. | `{{ load_date() }}` |
| `record_source` | A string identifying the source system. | `'seeds.raw_<source>'` |

### 2. Hubs (Silver)

Hubs store the unique list of business keys. They are **insert-only** and record the first time a key was seen.

*   **Primary Key**: `hk_<entity>`
*   **Business Key**: The natural identifier (e.g., `cust_id`, `prod_id`).
*   **Metadata**: `min(load_date)`, `min(record_source)`.

### 3. Links (Silver)

Links capture the relationship (many-to-many) between two or more Hubs.

*   **Primary Key**: `hk_<link_name>` (Computed in staging from the combination of all related business keys).
*   **Foreign Keys**: `hk_<hub1>`, `hk_<hub2>`, etc.
*   **Metadata**: `min(load_date)`, `min(record_source)`.

### 4. Satellites (Silver)

Satellites store the history of descriptive attributes and track changes over time.

*   **Foreign Key**: `hk_<entity>` (Links back to the parent Hub or Link).
*   **Change Detection**: `hash_diff` (Used to identify if a row has changed since the last load).
*   **Payload**: All descriptive attributes (e.g., `cust_email`, `price`, `is_active`).
*   **Metadata**: `load_date`, `record_source`.


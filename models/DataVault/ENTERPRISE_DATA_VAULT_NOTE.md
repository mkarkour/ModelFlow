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

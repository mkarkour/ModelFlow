"""EXERCISE: Star Schema Gold — Monthly Sales Anomaly Detection (Python Model).

PURPOSE:
Used to automatically flag months where a product category's revenue deviates
significantly from its recent trend. Aggregates fact data into monthly category
totals and applies a 3-month rolling mean ± 2 standard deviations to identify
outliers. Gives business stakeholders an early-warning signal for unusual sales
patterns without manual review.

HINTS:
1. Fetch DataFrames: Use `dbt.ref("...").df()` to pull in `fact_sales`, `dim_product_scd2`, and `dim_date`.
2. Filter: Remove "Cancelled" orders from the fact table.
3. Merge (Join): 
   - Left merge fact with products on `product_sk` (bring in `category`).
   - Left merge fact with dates on `order_date_key` = `date_key` (bring in date labels).
4. Aggregate: Group by category, year, month_num, month_name, year_month.
   - Calculate total_revenue (sum of gross_revenue)
   - Calculate total_orders (nunique of order_id)
   - Calculate total_units (sum of quantity)
5. Sort & Round: Sort chronologically within each category. Round total_revenue to 2 decimal places.
6. Rolling Stats: Over a 3-month rolling window (`min_periods=1`) grouped by `category`:
   - Calculate `rolling_avg_3m`
   - Calculate `rolling_std_3m` (fill NaNs with 0)
7. Bounds & Anomalies:
   - `upper_bound` = avg + 2 * std
   - `lower_bound` = avg - 2 * std
   - Flag `is_anomaly` if total_revenue is > upper_bound or < lower_bound.
   - Compute `deviation_pct` = ((total_revenue - avg) / avg) * 100.
8. Materialization: Make sure to set `dbt.config` with `materialized="table"` and `schema="ss_gold"`.
"""

import pandas as pd
import duckdb


def model(dbt, session):
    """Build a monthly sales anomaly report from the Star Schema fact and dimensions.

    Args:
        dbt: The dbt model context providing ref(), config(), and this().
        session: The DuckDB session (unused for DataFrame-based models).

    Returns:
        pd.DataFrame: Monthly category-level revenue with anomaly flags.
    """
    # TODO: Set dbt.config(materialized="table", schema="ss_gold", tags=["star_schema", "gold", "python"])
    
    # TODO: Fetch DataFrames from `fact_sales`, `dim_product_scd2`, and `dim_date`
    
    # TODO: Filter fact table to exclude "Cancelled" orders
    
    # TODO: Merge (join) active fact records with products and dates
    
    # TODO: Aggregate metrics (total_revenue, total_orders, total_units) grouped by category and month/year
    
    # TODO: Compute 3-month rolling mean (`rolling_avg_3m`) and standard dev (`rolling_std_3m`) for revenue by category
    
    # TODO: Calculate `upper_bound` and `lower_bound` (+/- 2 std dev from avg)
    
    # TODO: Boolean flag `is_anomaly` if revenue is outside bounds
    
    # TODO: Compute `deviation_pct`
    
    # TODO: Return final DataFrame
    return None

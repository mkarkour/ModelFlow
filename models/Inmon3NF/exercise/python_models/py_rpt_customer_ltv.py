"""EXERCISE: Inmon 3NF Gold — Customer Lifetime Value Analysis (Python Model).

PURPOSE:
Used to score and segment customers by their lifetime value to the business.
Computes purchase frequency, projected annual value, and total revenue per
customer, then assigns each to a High / Medium / Low CLV tier. Gives the
marketing team a prioritization framework for retention and upsell campaigns.

HINTS:
1. Fetch `dim_customer_3nf` and `fact_order_3nf`.
2. Filter out "Cancelled" orders from the fact.
3. Group by `cust_id` and calculate:
   - `total_orders`: nunique
   - `total_revenue`: sum of gross_revenue
   - `total_margin`: sum of gross_margin
   - `first_order` & `last_order`: min and max of order_date
4. Compute features:
   - `customer_lifespan_days`: (last - first).dt.days
   - `avg_order_value`: total_revenue / total_orders
   - `avg_margin_per_order`: total_margin / total_orders
   - `purchase_frequency`: total_orders / max(lifespan, 1) * 365
   - `projected_annual_value`: avg_order_value * purchase_frequency
5. Rank CLV using quantiles (e.g., top 33%, bottom 33% using `.quantile()`) into Tiers (High, Medium, Low).
6. Merge back with `dim_customer_3nf` to bring in `cust_name`, `cust_segment`, `cust_country`.
"""

import pandas as pd
import duckdb


def model(dbt, session):
    """Build a customer lifetime value analysis table from the 3NF CDW."""

    # TODO: Configure the model with materialized="table" and schema="inmon_gold"

    # TODO: Fetch DataFrames dim_customer_3nf and fact_order_3nf via dbt.ref()
    
    # TODO: Exclude cancelled orders
    
    # TODO: Group by cust_id and aggregate core lifetime metrics (span, revenue, orders)
    
    # TODO: Compute calculated ratios (avg order value, frequency per year, projected annual value)
    
    # TODO: Segment customers into `clv_tier` using pandas .quantile() thresholds
    
    # TODO: Join aggregated LTV stats back to the descriptive customer dimension columns
    
    # TODO: Return final DataFrame
    return None

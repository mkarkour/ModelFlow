"""Inmon 3NF Gold — Customer Lifetime Value Analysis (Python Model).

Compute Customer Lifetime Value (CLV) metrics including purchase frequency,
average order value, churn probability estimation, and projected annual value.
These statistical computations involve conditional logic and date arithmetic
that benefit from pandas expressiveness.

Materialization: table
Schema: inmon_gold
"""

import pandas as pd 
import duckdb


def model(dbt, session):
    """Build a customer lifetime value analysis table from the 3NF CDW.

    Args:
        dbt: The dbt model context providing ref(), config(), and this().
        session: The DuckDB session (unused for DataFrame-based models).

    Returns:
        pd.DataFrame: Customer-level CLV metrics and tier assignments.
    """
    dbt.config(
        materialized="table",
        schema="inmon_gold",
        tags=["inmon_3nf", "gold", "python"],
    )

    customers = dbt.ref("dim_customer_3nf").df()
    orders = dbt.ref("fact_order_3nf").df()

    active_orders = orders[orders["order_status"] != "Cancelled"].copy()

    agg = (
        active_orders.groupby("cust_id")
        .agg(
            total_orders=("order_id", "nunique"),
            total_revenue=("gross_revenue", "sum"),
            total_margin=("gross_margin", "sum"),
            first_order=("order_date", "min"),
            last_order=("order_date", "max"),
        )
        .reset_index()
    )

    agg["customer_lifespan_days"] = (agg["last_order"] - agg["first_order"]).dt.days
    agg["avg_order_value"] = (agg["total_revenue"] / agg["total_orders"]).round(2)
    agg["avg_margin_per_order"] = (agg["total_margin"] / agg["total_orders"]).round(2)

    agg["purchase_frequency"] = agg.apply(
        lambda r: (
            r["total_orders"] / max(r["customer_lifespan_days"], 1) * 365
        ),
        axis=1,
    ).round(2)

    agg["projected_annual_value"] = (
        agg["avg_order_value"] * agg["purchase_frequency"]
    ).round(2)

    agg["total_revenue"] = agg["total_revenue"].round(2)
    agg["total_margin"] = agg["total_margin"].round(2)

    p33 = agg["projected_annual_value"].quantile(0.33)
    p66 = agg["projected_annual_value"].quantile(0.66)

    def assign_tier(val):
        """Assign a CLV tier based on projected annual value percentile thresholds."""
        if val >= p66:
            return "High"
        elif val >= p33:
            return "Medium"
        else:
            return "Low"

    agg["clv_tier"] = agg["projected_annual_value"].apply(assign_tier)

    result = customers[["cust_id", "cust_name", "cust_segment", "cust_country"]].merge(
        agg, on="cust_id", how="inner"
    )

    return result

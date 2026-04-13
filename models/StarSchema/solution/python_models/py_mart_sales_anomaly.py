"""Star Schema Gold — Monthly Sales Anomaly Detection (Python Model).

Flag monthly revenue anomalies per product category using rolling statistics.
Anomalies are detected when a month's revenue deviates beyond 2 standard
deviations from the trailing 3-month rolling average. This type of windowed
statistical analysis with conditional flagging is significantly more readable
in pandas than in SQL.

Materialization: table
Schema: ss_gold
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
    dbt.config(
        materialized="table",
        schema="ss_gold",
        tags=["star_schema", "gold", "python"],
    )

    fact = dbt.ref("fact_sales").df()
    products = dbt.ref("dim_product_scd2").df()
    dates = dbt.ref("dim_date").df()

    active = fact[fact["order_status"] != "Cancelled"].copy()

    enriched = active.merge(
        products[["product_sk", "category"]], on="product_sk", how="left"
    ).merge(
        dates[["date_key", "year", "month_num", "month_name", "year_month"]],
        left_on="order_date_key",
        right_on="date_key",
        how="left",
    )

    monthly = (
        enriched.groupby(["category", "year", "month_num", "month_name", "year_month"])
        .agg(
            total_revenue=("gross_revenue", "sum"),
            total_orders=("order_id", "nunique"),
            total_units=("quantity", "sum"),
        )
        .reset_index()
        .sort_values(["category", "year", "month_num"])
    )

    monthly["total_revenue"] = monthly["total_revenue"].round(2)

    monthly["rolling_avg_3m"] = (
        monthly.groupby("category")["total_revenue"]
        .transform(lambda x: x.rolling(window=3, min_periods=1).mean())
        .round(2)
    )

    monthly["rolling_std_3m"] = (
        monthly.groupby("category")["total_revenue"]
        .transform(lambda x: x.rolling(window=3, min_periods=1).std())
        .fillna(0)
        .round(2)
    )

    monthly["upper_bound"] = (
        monthly["rolling_avg_3m"] + 2 * monthly["rolling_std_3m"]
    ).round(2)
    monthly["lower_bound"] = (
        monthly["rolling_avg_3m"] - 2 * monthly["rolling_std_3m"]
    ).round(2)

    monthly["is_anomaly"] = (
        (monthly["total_revenue"] > monthly["upper_bound"])
        | (monthly["total_revenue"] < monthly["lower_bound"])
    )

    monthly["deviation_pct"] = (
        ((monthly["total_revenue"] - monthly["rolling_avg_3m"]) / monthly["rolling_avg_3m"])
        * 100
    ).round(2)

    return monthly

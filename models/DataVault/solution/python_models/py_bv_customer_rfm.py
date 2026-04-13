"""Data Vault Gold — Customer RFM Segmentation (Python Model).

Compute Recency, Frequency, and Monetary (RFM) scores for each customer using
the Business Vault sales summary. RFM segmentation involves percentile-based
binning logic that is verbose and fragile in pure SQL but concise in pandas.

Materialization: table
Schema: dv_gold
"""

import pandas as pd 
import duckdb


def model(dbt, session):
    """Build a customer RFM segmentation table from the Data Vault Business Vault.

    Args:
        dbt: The dbt model context providing ref(), config(), and this().
        session: The DuckDB session (unused for DataFrame-based models).

    Returns:
        pd.DataFrame: Customer-level RFM scores and segment labels.
    """
    dbt.config(
        materialized="table",
        schema="dv_gold",
        tags=["data_vault", "gold", "python"],
    )

    bv_sales = dbt.ref("bv_sales_summary")
    df = bv_sales.df()

    df_active = df[df["order_status"] != "Cancelled"].copy()

    max_date = df_active["order_date"].max()

    rfm = (
        df_active.groupby("hk_customer")
        .agg(
            cust_name=("cust_name", "first"),
            cust_segment=("cust_segment", "first"),
            recency_days=("order_date", lambda x: (max_date - x.max()).days),
            frequency=("order_id", "nunique"),
            monetary=("gross_revenue", "sum"),
        )
        .reset_index()
    )

    rfm["monetary"] = rfm["monetary"].round(2)

    for metric in ["recency_days", "frequency", "monetary"]:
        col_name = f"{metric}_score"
        if metric == "recency_days":
            rfm[col_name] = pd.qcut(
                rfm[metric], q=4, labels=[4, 3, 2, 1], duplicates="drop"
            ).astype(int)
        else:
            rfm[col_name] = pd.qcut(
                rfm[metric], q=4, labels=[1, 2, 3, 4], duplicates="drop"
            ).astype(int)

    rfm["rfm_total_score"] = (
        rfm["recency_days_score"] + rfm["frequency_score"] + rfm["monetary_score"]
    )

    def assign_segment(score):
        """Assign a human-readable segment label based on the total RFM score."""
        if score >= 10:
            return "Champion"
        elif score >= 8:
            return "Loyal"
        elif score >= 6:
            return "Potential"
        elif score >= 4:
            return "At Risk"
        else:
            return "Hibernating"

    rfm["rfm_segment"] = rfm["rfm_total_score"].apply(assign_segment)

    return rfm


import pandas as pd  # noqa: E402 — required at module level for dbt-duckdb

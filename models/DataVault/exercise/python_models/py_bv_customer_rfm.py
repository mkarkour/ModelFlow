"""EXERCISE: Data Vault Gold — Customer RFM Segmentation (Python Model).

PURPOSE:
Used to segment customers by their purchasing behaviour using the RFM framework
(Recency, Frequency, Monetary). Scores each customer on three dimensions via
quartile binning and maps the combined score to named segments (Champion, Loyal,
At Risk, etc.). Gives CRM and marketing teams a behavioural taxonomy derived
directly from transaction history.

HINTS:
1. Fetch `bv_sales_summary`.
2. Filter out "Cancelled" orders.
3. Find the `max_date` from `order_date` across the entire dataframe to use as your "today" for Recency.
4. Calculate Recency, Frequency, Monetary grouped by `hk_customer` (keep `cust_name` and `cust_segment`).
   - Recency: `(max_date - order_date.max()).days`
   - Frequency: `order_id` (nunique)
   - Monetary: sum of `gross_revenue`
5. Round the Monetary amount to 2 decimal places.
6. Calculate scores using `pd.qcut` (quartiles 1 to 4).
   - Recency score: 4 is best (lowest days), 1 is worst. `labels=[4, 3, 2, 1]`
   - Frequency/Monetary score: 4 is best (highest), 1 is worst. `labels=[1, 2, 3, 4]`
7. Calculate `rfm_total_score` by adding the three scores.
8. Assign Segments manually based on the score (e.g. Champion >= 10, Loyal >= 8, etc.).
"""

import pandas as pd

def model(dbt, session):
    """Build a customer RFM segmentation table from the Data Vault Business Vault."""
    
    # TODO: Configure the model with materialized="table" and schema="dv_gold" (add tags if desired)
    
    # TODO: Load bv_sales_summary using dbt.ref()
    
    # TODO: Filter out cancelled orders
    
    # TODO: Calculate aggregations (Recency, Frequency, Monetary) per customer
    
    # TODO: Bin metrics into quartiles using pd.qcut to attribute scores 1-4
    
    # TODO: Sum scores to compute rfm_total_score
    
    # TODO: Create the rfm_segment label based on total score (e.g. "Champion", "At Risk")
    
    # TODO: Return final dataframe
    return None

/* EXERCISE: Create the Data Vault Business Vault sales summary.

   PURPOSE:
   Business Vault gold model that assembles a complete sales transaction view
   from the Raw Vault. Joins the Order Link to the three satellites (order,
   customer, product) to reconstitute a flat, analyst-friendly row per
   transaction with all descriptive context. Computes derived financial measures
   (gross_revenue, total_cost) that the Raw Vault intentionally omits. This is
   the main source consumed by the RFM segmentation Python model downstream.

   HINTS:
   1. Assemble data from {{ ref('link_order') }} and the Satellites.
   2. For each satellite, fetch the latest row (e.g., using row_number partitioned by the relevant hash key order by load_date desc).
   3. Left Join sat_order, sat_customer, and sat_product to link_order based on the appropriate hash keys.
   4. Compute derived metrics: `gross_revenue` and `total_cost`.
*/

with link as (
    -- TODO: Select all columns from {{ ref('link_order') }}
    -- YOUR CODE HERE
),

sat_order as (
    -- TODO: Select latest record from {{ ref('sat_order_details') }} 
    -- partition by hk_order_link order by load_date desc
    -- YOUR CODE HERE
),

sat_customer as (
    -- TODO: Select latest record from {{ ref('sat_customer_details') }}
    -- partition by hk_customer order by load_date desc
    -- YOUR CODE HERE
),

sat_product as (
    -- TODO: Select latest record from {{ ref('sat_product_details') }}
    -- partition by hk_product order by load_date desc
    -- YOUR CODE HERE
),

assembled as (
    -- TODO: Join link 'l' to sat_order 'so', sat_customer 'sc', and sat_product 'sp'
    -- TODO: Select keys, descriptive attributes, and order metrics
    -- TODO: Compute gross_revenue and total_cost with rounding
    -- YOUR CODE HERE
)

select
    -- TODO: Select all columns from the assembled CTE
    -- YOUR CODE HERE
from assembled

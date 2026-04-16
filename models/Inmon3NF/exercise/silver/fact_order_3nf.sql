/* EXERCISE: Inmon 3NF Silver - Order Fact (3NF CDW)

   PURPOSE:
   Central normalized fact table in the Inmon CDW at order grain. Stores only
   foreign keys (cust_id, prod_id) and computed measures — no customer names or
   product descriptions here, in strict adherence to 3NF. Joins dim_product_3nf
   to retrieve price and cost for calculating revenue, total cost, and gross
   margin. Gold reports join this fact back to dimension entities at query time.

   HINTS:
   1. The grain is one row per order line. Select from `bronze_3nf_stg_orders`.
   2. Enrich with product cost/price by joining `dim_product_3nf` on `prod_id` (so you can compute revenue).
   3. Note that this is 3NF, so do NOT bring customer or product descriptions like `cust_name` or `category` into the fact! Only bring keys (cust_id, prod_id).
   4. Calculate measures:
      - `unit_price`: from product
      - `unit_cost`: from product
      - `gross_revenue`: quantity * price * (1 - discount_pct / 100.0)
      - `total_cost`: quantity * cost
      - `gross_margin`: gross_revenue - total_cost
*/

with staged as (
    -- TODO: Select from bronze_3nf_stg_orders
    -- YOUR CODE HERE
),

products as (
    -- TODO: Select prod_id, price, cost from dim_product_3nf
    -- YOUR CODE HERE
)

select
    -- ── Keys
    -- TODO: order_id (PK), cust_id (FK), prod_id (FK)

    -- ── Order Attributes
    -- TODO: order_date, quantity, discount_pct, order_status, channel, payment_method

    -- ── Computed Measures
    -- TODO: unit_price, unit_cost, gross_revenue, total_cost, gross_margin

    -- ── Metadata
    -- TODO: _loaded_at

from staged o
-- TODO: left join products p

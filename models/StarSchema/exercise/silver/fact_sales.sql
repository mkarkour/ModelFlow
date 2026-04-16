/* EXERCISE: Star Schema Sales Fact Table.

   PURPOSE:
   Central fact table of the Star Schema at order grain (one row per order).
   Resolves natural keys to surrogate keys by joining the three dimensions
   (customer, product, date), then stores all additive financial measures
   (revenue, cost, margin) alongside semi-additive attributes. This table is
   the primary source for all downstream gold aggregations and BI marts.

   HINTS:
   1. Grain: one row per order. Base this on `bronze_ss_stg_orders`.
   2. Join `dim_customer_scd2` on `cust_id` AND `is_current = true` to get the latest `customer_sk`.
   3. Join `dim_product_scd2` on `prod_id` AND `is_current = true` to get `product_sk`.
   4. Join `dim_date` on `order_date = full_date` to get `date_key`.
   5. Select the surrogate keys from dimensions:
      - `customer_sk`, `product_sk`, `date_key` (alias as `order_date_key`).
   6. Retain the degenerate dimension: `order_id`.
   7. Bring over original and denormalized measures (`quantity`, `unit_price`, `unit_cost`, `discount_pct`, `gross_revenue`, `total_cost`).
   8. Calculate extra measures:
      - `gross_margin` = `gross_revenue` - `total_cost`
      - `gross_margin_pct` = safe division of `gross_margin` by `gross_revenue` * 100
   9. Include categorical attributes like `order_status`, `channel`, `payment_method`.
*/

with orders as (
    -- TODO: Select from bronze_ss_stg_orders
    -- YOUR CODE HERE
),

dim_customer as (
    -- TODO: Select customer_sk and cust_id from dim_customer_scd2 where is_current = true
    -- YOUR CODE HERE
),

dim_product as (
    -- TODO: Select product_sk and prod_id from dim_product_scd2 where is_current = true
    -- YOUR CODE HERE
),

dim_date as (
    -- TODO: Select date_key and full_date from dim_date
    -- YOUR CODE HERE
)

select
    -- ── Surrogate Keys (FKs to dimensions)
    -- TODO: customer_sk, product_sk, date_key as order_date_key

    -- ── Degenerate Dimension (natural key kept on fact)
    -- TODO: order_id

    -- ── Measures
    -- TODO: quantity, unit_price, unit_cost, discount_pct, gross_revenue, total_cost
    -- TODO: Calculate gross_margin and gross_margin_pct

    -- ── Semi-additive/non-additive attributes
    -- TODO: order_status, channel, payment_method, _loaded_at

from orders o
-- TODO: left join dim_customer, dim_product, dim_date

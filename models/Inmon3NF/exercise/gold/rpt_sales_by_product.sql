/* EXERCISE: Inmon 3NF Gold - Sales by Product Report
   
   HINTS:
   1. Filter out 'Cancelled' orders from `fact_order_3nf`.
   2. Grab `dim_product_3nf`.
   3. Group by product attributes and calculate metrics:
      - `total_orders`
      - `total_units_sold`
      - `total_gross_revenue`
      - `gross_margin_pct`: (sum(gross_margin) / sum(gross_revenue)) * 100
*/

with fact as (
    -- TODO: Select from fact_order_3nf where order_status != 'Cancelled'
    -- YOUR CODE HERE
),

products as (
    -- TODO: Select from dim_product_3nf
    -- YOUR CODE HERE
)

select
    -- ── Product Description
    -- TODO: prod_id, product_name, category, subcategory, sku, list_price (from product.price)

    -- ── Volume Metrics
    -- TODO: total_orders, total_units_sold

    -- ── Revenue Metrics
    -- TODO: total_gross_revenue, total_cost, total_gross_margin, gross_margin_pct
    
    -- ── Date range
    -- TODO: first_sale_date, last_sale_date
    
from products p
-- TODO: left join fact f on prod_id, group by product columns, filter where total_orders > 0

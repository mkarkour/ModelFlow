/* EXERCISE: Create a denormalized Sales Mart for BI dashboards.
   
   HINTS:
   1. Select from the fact_sales model and filter out cancelled orders.
   2. Join with the current active records of the customer dimension and product dimension using Surrogate Keys.
   3. Join with the date dimension using the date block key.
   4. Pull in the Order ID degenerate dimension.
   5. Pull in the rich descriptive attributes from the customer, product, and date dimensions to create a wide, flat table optimized for BI tools.
   6. Include transaction details from the fact table.
   7. Include all computed measures from the fact table.
*/

with fact as (
    -- TODO: Select from the fact_sales model and filter out cancelled orders.
    -- YOUR CODE HERE
),

dim_customer as (
    -- TODO: Select the current records from the customer dimension (is_current = true).
    -- YOUR CODE HERE
),

dim_product as (
    -- TODO: Select the current records from the product dimension.
    -- YOUR CODE HERE
),

dim_date as (
    -- TODO: Select from the date dimension.
    -- YOUR CODE HERE
)

select
    -- ── Order Identifiers
    -- TODO: order_id

    -- ── Customer Attributes
    -- TODO: cust_id, cust_name, email, country, city, segment

    -- ── Product Attributes
    -- TODO: prod_id, product_name, category, subcategory, sku

    -- ── Date Attributes
    -- TODO: full_date, year, quarter, month_num, month_name, week_of_year, etc.

    -- ── Transaction Details
    -- TODO: channel, payment_method, order_status

    -- ── Measures
    -- TODO: quantity, unit_price, unit_cost, discount_pct, gross_revenue, total_cost, gross_margin, gross_margin_pct

from fact f
-- TODO: left join dimensions

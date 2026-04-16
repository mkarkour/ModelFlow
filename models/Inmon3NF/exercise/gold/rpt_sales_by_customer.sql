/* EXERCISE: Inmon 3NF Gold - Sales by Customer Report

   PURPOSE:
   Used to report lifetime sales activity aggregated per customer. Joins the
   normalized order fact to the customer entity and surfaces order count, units
   sold, revenue, cost, margin, and order date range. Consumed by sales and CRM
   teams to evaluate individual customer performance.

   HINTS:
   1. Filter out 'Cancelled' orders from `fact_order_3nf`.
   2. Grab `dim_customer_3nf`.
   3. Group by customer attributes and calculate order metrics:
      - `total_orders`: count of order_id
      - `total_units_sold`: sum of quantity
      - `total_gross_revenue`: sum of gross_revenue, etc.
   4. Calculate date metrics (first_order_date, last_order_date, customer_lifetime_days).
*/

with fact as (
    -- TODO: Select from fact_order_3nf where order_status is not Cancelled
    -- YOUR CODE HERE
),

customers as (
    -- TODO: Select from dim_customer_3nf
    -- YOUR CODE HERE
)

select
    -- ── Customer Description
    -- TODO: cust_id, cust_name, cust_country, cust_segment, cust_city

    -- ── Order Metrics
    -- TODO: count of orders, sum of quantity

    -- ── Revenue Metrics
    -- TODO: total_gross_revenue, total_cost, total_gross_margin, avg_order_value
    
    -- ── Date Metrics
    -- TODO: first_order_date, last_order_date, customer_lifetime_days
    
from customers c
-- TODO: left join fact f on cust_id, group by customer columns, filter where total_orders > 0

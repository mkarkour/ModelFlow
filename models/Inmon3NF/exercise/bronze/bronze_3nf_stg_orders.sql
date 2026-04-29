/* EXERCISE: Inmon 3NF Bronze - Staging Orders

   PURPOSE:
   First ingestion layer for order data in the Inmon 3NF pipeline. Cleanses
   categorical string fields (status, channel, payment_method) before they reach
   the normalized fact table. No joins or measures computed here — the 3NF fact
   handles enrichment with a separate product join at the silver layer.

   HINTS:
   1. Select from the `raw_orders` seed.
   2. Cleanse string attributes (e.g., status, channel): cast them to `varchar` and apply `trim()` to remove whitespaces.
*/

with orders as (
    -- TODO: Select all columns from {{ ref('raw_orders') }}
    -- YOUR CODE HERE
),

products as (
    -- TODO: Select prod_id, price, and cost from {{ ref('raw_products') }}
    -- YOUR CODE HERE
),

staged as (
    -- TODO: Join orders and products on prod_id
    -- TODO: Cast keys and dates (order_id, cust_id, order_date)
    -- TODO: Trim string fields (status, channel, payment_method)
    -- TODO: Calculate gross_revenue and total_cost (round to 2 decimal places)
    -- YOUR CODE HERE
)

select
    -- TODO: Select all columns from staged
    -- TODO: Include {{ load_date() }} as _loaded_at
    -- YOUR CODE HERE
from staged

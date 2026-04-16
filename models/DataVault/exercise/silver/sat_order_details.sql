/* EXERCISE: Create a Data Vault Silver Satellite for order details (context on the link).

   PURPOSE:
   Used to store transactional attributes (order_date, quantity, discount,
   status, channel, payment_method) that describe each relationship recorded in
   the Order Link. Keyed by hk_order_link and holds the latest record per link
   row. Consumed by the Business Vault sales summary to reconstitute full order
   context.

   HINTS:
   1. Select from {{ ref('bronze_dv_stg_orders') }}
   2. Similar to sat_customer_details, select the latest record, but partition by hk_order_link.
   3. Order by load_date descending and get the top row.
   4. Include descriptive attributes: order_date, quantity, discount_pct, order_status, channel, payment_method.
*/

-- Your code here:
with source_data as (
    -- select ...
),

latest_records as (
    -- select ...
)

select
    -- ...
from latest_records
-- where row_num = 1

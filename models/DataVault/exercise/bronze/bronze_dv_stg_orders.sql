/* EXERCISE: Create a Data Vault staging model for orders.
   
   HINTS:
   1. Select from {{ ref('raw_orders') }}
   2. Cast keys: order_id, cust_id, prod_id to integer.
   3. Generate Hash Keys for Hubs:
      - hk_order from order_id
      - hk_customer from cust_id
      - hk_product from prod_id
   4. Generate Hash Key for Link:
      - hk_order_link from order_id, cust_id, prod_id
   5. Generate Hash Diff for Satellite from descriptive attributes (order_date, quantity, discount_pct, status, channel, payment_method).
   6. Include load_date and record_source.
*/

-- Your code here:
with source as (
    -- select ...
),

staged as (
    -- select ...
)

select * from staged

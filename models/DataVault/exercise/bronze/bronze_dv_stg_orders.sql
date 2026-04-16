/* EXERCISE: Create a Data Vault staging model for orders.

   PURPOSE:
   Data Vault staging layer for order records. Produces three hub hash keys
   (hk_order, hk_customer, hk_product) and one composite link hash key
   (hk_order_link) that captures the three-way relationship between an order,
   its customer, and its product. Also computes a hash_diff over order descriptors
   for change detection in the order satellite. This single staging model feeds
   the order Hub, the Link, and the order Satellite.

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

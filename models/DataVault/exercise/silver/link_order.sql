/* EXERCISE: Implement a Data Vault Link for Orders.

   PURPOSE:
   Used to record the transactional relationship between a Customer, a Product,
   and an Order in the Raw Vault. Stores only hash keys (hk_order_link,
   hk_order, hk_customer, hk_product) and the natural order_id — no descriptive
   data. The order satellite attaches context to each link row via hk_order_link.

   HINTS:
   1. Capture the transaction relationship between customer, product, and order.
   2. Select from {{ ref('bronze_dv_stg_orders') }}.
   3. Select hk_order_link, hk_order, hk_customer, hk_product, order_id.
   4. Group by these five fields and select min(load_date) and min(record_source) to get the first seen.
   5. A link table only contains hash keys and relationship business keys, strictly no descriptive attributes.
*/

with source as (
    -- TODO: Select all columns from {{ ref('bronze_dv_stg_orders') }}
    -- YOUR CODE HERE
),

link_order as (
    -- TODO: Select the link hash key, component hash keys, and the business key
    -- TODO: Group by all keys and take the min(load_date)
    -- YOUR CODE HERE
)

select * from link_order

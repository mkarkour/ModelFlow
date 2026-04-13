/* EXERCISE: Implement a Data Vault Link for Orders.
   
   PATH: models/DataVault/exercise/silver/link_order.sql
   
   HINTS:
   1. Capture the transaction relationship between customer, product, and order.
   2. Select from {{ ref('bronze_dv_stg_orders') }}.
   3. Select hk_order_link, hk_order, hk_customer, hk_product, order_id.
   4. Group by these five fields and select min(load_date) and min(record_source) to get the first seen.
   5. A link table only contains hash keys and relationship business keys, strictly no descriptive attributes.
*/

-- Your code here:
with source_data as (
    -- select ...
),

link_order as (
    -- select ...
)

select * from link_order

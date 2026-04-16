/* EXERCISE: Create a Data Vault Silver Hub for products.

   PURPOSE:
   Used to maintain the unique set of product business keys (prod_id) ever seen
   in the source system. Stores hk_product, prod_id, and first-seen load date
   — no descriptive attributes. The product satellite attaches descriptors to
   this hub via hk_product.

   HINTS:
   1. Select from {{ ref('bronze_dv_stg_products') }}
   2. A Hub needs a unique list of business keys. Group by hk_product and prod_id.
   3. Get the first load date (min) and the first record_source (min).
*/

-- Your code here:
with source_data as (
    -- select ...
),

hub_product as (
    -- select ...
)

select * from hub_product

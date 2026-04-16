/* EXERCISE: Implement a Data Vault Satellite for product details.

   PURPOSE:
   Data Vault Satellite that stores descriptive product attributes (name, category,
   subcategory, price, cost, sku, is_active) linked to the Product Hub via
   hk_product. Selecting only the latest record per product (via window function)
   reflects the current product state used downstream in Business Vault and gold
   sales summary models.

   HINTS:
   1. Select from {{ ref('bronze_dv_stg_products') }}.
   2. Select the latest record per hk_product to capture the most recent state.
   3. Use a Window Function to partition by hk_product and order by load_date desc.
   4. Select hk_product, hash_diff, product_name, category, subcategory, price, cost, sku, is_active, load_date, record_source.
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
-- where ...

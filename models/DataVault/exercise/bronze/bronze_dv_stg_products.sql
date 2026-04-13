/* EXERCISE: Create a staging model for Data Vault products.
   
   PATH: models/DataVault/exercise/bronze/bronze_dv_stg_products.sql
   
   HINTS:
   1. Select from {{ ref('raw_products') }}.
   2. Compute hk_product (hash_key on ['prod_id']) and hash_diff on descriptive fields.
   3. Cast prod_id to integer, price and cost to double, is_active to boolean.
   4. Include load_date() and 'seeds.raw_products' as record_source.
*/

-- Your code here:
with source as (
    -- select ...
),

staged as (
    -- select ...
)

select * from staged

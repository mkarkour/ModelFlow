/* EXERCISE: Create a staging model for Data Vault products.

   PURPOSE:
   Data Vault staging layer for product records. Generates hk_product (hash of
   prod_id) and a hash_diff over all descriptive product fields. Casts raw seed
   types to their target types (integer, double, boolean) and attaches load
   metadata (load_date, record_source). Feeds both the product Hub and the
   product Satellite in the silver layer.

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

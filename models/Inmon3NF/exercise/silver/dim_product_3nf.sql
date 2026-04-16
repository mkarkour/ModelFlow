/* EXERCISE: Inmon 3NF Silver - Product Entity (3NF CDW)

   PURPOSE:
   Normalized product entity table in the Inmon CDW. Stores one row per product
   keyed by prod_id, containing pricing (price, cost), classification (category,
   subcategory), and availability (is_active). The fact table joins this entity
   to retrieve unit price and cost when computing financial measures — keeping
   the fact lean and avoiding redundancy.

   HINTS:
   1. Select from `bronze_3nf_stg_products`.
   2. Select normal product attributes.
*/

with staged as (
    -- TODO: Select from bronze_3nf_stg_products
    -- YOUR CODE HERE
)

select
    -- TODO: Select prod_id (PK), product_name, category, subcategory, price, cost, sku, is_active, _loaded_at
    -- YOUR CODE HERE
from staged

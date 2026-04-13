/* EXERCISE: Create a Star Schema SCD Type 2 product dimension.
   
   HINTS:
   1. Select from `bronze_ss_stg_products`.
   2. We are simulating a single active version per product for simplicity.
   3. Generate `product_sk` using `{{ dbt_utils.generate_surrogate_key(['prod_id', "'2020-01-01'"]) }}`.
   4. Hardcode SCD2 temporal columns:
      - `valid_from`: cast '2020-01-01' as date
      - `valid_to`: cast '9999-12-31' as date
      - `is_current`: true
      - `version`: 1
*/

with staged as (
    -- TODO: Select from bronze_ss_stg_products
    -- YOUR CODE HERE
)

select
    -- TODO: Generate product_sk using {{ dbt_utils.generate_surrogate_key(['prod_id', "'2020-01-01'"]) }}
    -- TODO: Select staging columns (prod_id, product_name, category, subcategory, price, cost, sku, is_active)
    -- TODO: Add SCD2 temporal columns (valid_from, valid_to, is_current, version)
    -- YOUR CODE HERE
from staged

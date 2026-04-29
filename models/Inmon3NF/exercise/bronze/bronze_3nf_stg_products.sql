/* EXERCISE: Inmon 3NF Bronze - Staging Products

   PURPOSE:
   First ingestion layer for product data in the Inmon 3NF pipeline. Selects raw
   product records from the seed and trims string attributes before they populate
   the normalized silver product entity. No price logic or joins — pure technical
   cleansing only.

   HINTS:
   1. Select from the `raw_products` seed.
   2. Cleanse string attributes (e.g., product_name, category): cast them to `varchar` and apply `trim()` to remove trailing whitespaces.
*/

with source as (
    -- TODO: Select all columns from {{ ref('raw_products') }}
    -- YOUR CODE HERE
),

staged as (
    -- TODO: Cast prod_id, price, cost, and is_active to their proper types
    -- TODO: Trim whitespace from product_name, category, and subcategory
    -- TODO: Standardize SKU by trimming and converting to UPPER case
    -- TODO: Include the {{ load_date() }} macro as _loaded_at
    -- YOUR CODE HERE
)

select 
    -- TODO: Select all columns from the staged CTE
    -- YOUR CODE HERE
from staged

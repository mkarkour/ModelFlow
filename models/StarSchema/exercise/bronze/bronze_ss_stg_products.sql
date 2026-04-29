/* EXERCISE: Create a staging model for Star Schema products.

   PURPOSE:
   Entry-point staging for raw product data in the Star Schema pipeline.
   Casts numeric and boolean fields to correct types, trims string columns,
   and exposes all product attributes required by the downstream SCD Type 2
   product dimension.

   HINTS:
   1. Select from the raw_products seed
   2. Cast columns to appropriate types (integer, double, boolean)
   3. Clean string columns (trim whitespace, normalize SKU)
   4. Include all product attributes needed by the SCD2 dimension
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

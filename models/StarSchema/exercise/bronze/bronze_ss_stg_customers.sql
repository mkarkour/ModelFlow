/* EXERCISE: Create a staging model for Star Schema customers.

   PURPOSE:
   First landing zone for raw customer data in the Star Schema pipeline.
   Standardizes types, cleans strings, and exposes temporal columns (created_at,
   updated_at) that drive SCD Type 2 history in the downstream customer dimension.

   HINTS:
   1. Select from the raw_customers seed
   2. Cast columns to appropriate types (integer, date)
   3. Clean string columns (trim whitespace, normalize email)
   4. Include temporal columns needed for SCD2 tracking downstream
*/

with source as (
    -- TODO: Select all columns from {{ ref('raw_customers') }}
    -- YOUR CODE HERE
),

staged as (
    -- TODO: Cast cust_id to integer and date fields to date
    -- TODO: Clean and rename string fields (name, country, city, segment)
    -- TODO: Format email by trimming and converting to LOWER case
    -- TODO: Include the {{ load_date() }} macro as _loaded_at
    -- YOUR CODE HERE
)

select
    -- TODO: Select all columns from the staged CTE
    -- YOUR CODE HERE
from staged
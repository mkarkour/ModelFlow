/* EXERCISE: Inmon 3NF Bronze - Staging Customers

   PURPOSE:
   First ingestion layer for customer data in the Inmon 3NF pipeline. Selects
   raw customer records from the seed and applies minimal cleansing (type casts,
   string trimming) before handing off to the normalized silver customer entity.
   No business logic here — only technical cleansing.

   HINTS:
   1. Select from the `raw_customers` seed.
   2. Cleanse string attributes: cast them to `varchar` and apply `trim()` to remove trailing whitespaces.
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

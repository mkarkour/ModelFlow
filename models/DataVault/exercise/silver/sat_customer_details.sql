/* EXERCISE: Create a Data Vault Silver Satellite for customer details.

   PURPOSE:
   Used to store the current descriptive attributes of each customer (name,
   email, country, city, segment), linked to the Customer Hub via hk_customer.
   Keeps the latest record per customer using a window function. Consumed by
   Business Vault and gold models that need current customer descriptors.

   HINTS:
   1. Select from {{ ref('bronze_dv_stg_customers') }}
   2. Select the latest record per hk_customer.
   3. You can use window functions (e.g., row_number() over (partition by hk_customer order by load_date desc)).
   4. The output must include the hash key, hash diff, descriptive fields, load_date, and record_source.
*/

with source as (
    -- TODO: Select all columns from {{ ref('bronze_dv_stg_customers') }}
    -- YOUR CODE HERE
),

latest_records as (
    -- TODO: Select descriptive columns (name, email, country, city, segment)
    -- TODO: Use row_number() over hk_customer ordered by load_date desc
    -- YOUR CODE HERE
)

select
    -- TODO: Select all columns (excluding the row_number column)
    -- TODO: Filter for row_num = 1
    -- YOUR CODE HERE
from latest_records

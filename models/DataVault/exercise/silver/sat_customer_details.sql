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
-- where row_num = 1

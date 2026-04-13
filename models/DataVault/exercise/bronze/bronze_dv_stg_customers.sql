/* EXERCISE: Create a staging model for Data Vault customers.
   
   PATH: models/DataVault/exercise/bronze/bronze_dv_stg_customers.sql
   
   HINTS:
   1. Select from {{ ref('raw_customers') }}
   2. Use the `hash_key` macro on ['cust_id'] to create 'hk_customer'.
   3. Use the `hash_diff` macro on descriptive fields (name, email, country, city, segment) to create 'hash_diff'.
   4. Include `load_date()` as 'load_date'.
   5. Explicitly cast `cust_id` to integer, and dates to date.
*/

-- Your code here:
with source as (
    -- select ...
),

staged as (
    -- select ...
)

select * from staged

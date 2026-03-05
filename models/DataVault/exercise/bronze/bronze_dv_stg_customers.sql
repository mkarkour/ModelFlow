/* EXERCISE: Create a staging model for Data Vault customers.
   
   HINTS:
   1. Select from {{ ref('raw_customers') }}
   2. Use the `generate_hash_key` macro on 'cust_id' to create 'hk_customer'.
   3. Use the `hash_diff` macro on descriptive fields to create 'hash_diff'.
   4. Include `current_load_date()` as 'load_date'.
*/

-- Your code here:
select
    -- hk_customer,
    -- hash_diff,
    -- ...
from {{ ref('raw_customers') }}

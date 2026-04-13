/* EXERCISE: Inmon 3NF Silver - Customer Entity (3NF CDW)
   
   HINTS:
   1. Select from `bronze_3nf_stg_customers`.
   2. Select normal customer attributes and metadata columns.
*/

with staged as (
    -- TODO: Select from bronze_3nf_stg_customers
    -- YOUR CODE HERE
)

select
    -- TODO: Select cust_id (PK), cust_name, cust_email, cust_country, cust_city, cust_segment, created_at, updated_at, _loaded_at
    -- YOUR CODE HERE
from staged

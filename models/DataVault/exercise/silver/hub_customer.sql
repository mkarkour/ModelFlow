/* EXERCISE: Implement a Data Vault Hub for Customers.
   
   PATH: models/DataVault/exercise/silver/hub_customer.sql
   
   HINTS:
   1. Hubs store unique Business Keys.
   2. Select distinct hk_customer, cust_id, load_date, record_source from {{ ref('bronze_dv_stg_customers') }}.
   3. Ensure you only keep the first occurrence of a business key if there are duplicates (e.g. min(load_date), min(record_source)) grouping by hk_customer and cust_id.
*/

-- Your code here:
with source_data as (
    -- select ...
),

hub_customer as (
    -- select ...
)

select * from hub_customer

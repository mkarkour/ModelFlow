/* EXERCISE: Implement a Data Vault Hub for Customers.

   PURPOSE:
   Used to maintain the unique set of customer business keys (cust_id) ever seen
   in the source system. Stores hk_customer, cust_id, and first-seen load
   metadata — no descriptive attributes. All customer satellites and links
   reference this hub via hk_customer.

   HINTS:
   1. Hubs store unique Business Keys.
   2. Select distinct hk_customer, cust_id, load_date, record_source from {{ ref('bronze_dv_stg_customers') }}.
   3. Ensure you only keep the first occurrence of a business key if there are duplicates (e.g. min(load_date), min(record_source)) grouping by hk_customer and cust_id.
*/

with source as (
    -- TODO: Select all columns from {{ ref('bronze_dv_stg_customers') }}
    -- YOUR CODE HERE
),

hub_customer as (
    -- TODO: Select hk_customer and cust_id
    -- TODO: Use min() to find the earliest load_date and record_source
    -- TODO: Group by the hash key and business key
    -- YOUR CODE HERE
)

select
    -- TODO: Select all columns from the hub_customer CTE
    -- YOUR CODE HERE
from hub_customer

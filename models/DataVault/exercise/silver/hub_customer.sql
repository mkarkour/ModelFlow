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

-- Your code here:
with source_data as (
    -- select ...
),

hub_customer as (
    -- select ...
)

select * from hub_customer

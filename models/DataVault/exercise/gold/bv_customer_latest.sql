/* EXERCISE: Create a Business Vault Gold model showing the latest customer view.

   PURPOSE:
   Used to expose a single current-state row per customer by joining the Customer
   Hub to its latest Satellite record. Provides a consumer-friendly view of
   current customer data (identity + descriptors + dates) without requiring
   downstream models to understand raw vault join patterns.

   HINTS:
   1. Join the Hub {{ ref('hub_customer') }} to the Satellite {{ ref('sat_customer_details') }}.
   2. Filter for the latest satellite record per hub key (use window function or cross reference with satellite logic if it already has latest).
   3. The result provides a "current state" perspective over the raw vault.
   4. Output Hub keys (hk_customer, cust_id), Satellite descriptors (cust_name, etc.), and Dates (first_seen_date from hub and last_updated_date from sat).
*/

-- Your code here:
with hub as (
    -- select * from {{ ref('hub_customer') }}
),

sat as (
    -- select * from {{ ref('sat_customer_details') }}
),

latest_sat as (
    -- select ..., row_number() over (partition by hk_customer order by load_date desc) as rn
)

select
    -- ...
from hub h
-- left join latest_sat s on ...

/* EXERCISE: Create the Data Vault Business Vault sales summary.
   
   PATH: models/DataVault/exercise/gold/bv_sales_summary.sql
   
   HINTS:
   1. Assemble data from {{ ref('link_order') }} and the Satellites.
   2. For each satellite, fetch the latest row (e.g., using row_number partitioned by the relevant hash key order by load_date desc).
   3. Left Join sat_order, sat_customer, and sat_product to link_order based on the appropriate hash keys.
   4. Compute derived metrics: `gross_revenue` and `total_cost`.
*/

-- Your code here:
with link as (
    -- select * from {{ ref('link_order') }}
),

sat_order as (
    -- select ... from {{ ref('sat_order_details') }} where latest
),

sat_customer as (
    -- select ... from {{ ref('sat_customer_details') }} where latest
),

sat_product as (
    -- select ... from {{ ref('sat_product_details') }} where latest
),

assembled as (
    -- select ...
    -- from link l
    -- left join sat_order so on ...
    -- left join sat_customer sc on ...
    -- left join sat_product sp on ...
)

select * from assembled

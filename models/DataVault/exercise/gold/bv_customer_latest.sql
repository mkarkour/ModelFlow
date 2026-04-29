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

with hub as (
    -- TODO: Select all columns from {{ ref('hub_customer') }}
    -- YOUR CODE HERE
),

sat as (
    -- TODO: Select all columns from {{ ref('sat_customer_details') }}
    -- YOUR CODE HERE
),

latest_sat as (
    -- TODO: Use row_number() over hk_customer ordered by load_date desc
    -- TODO: This ensures we only join to the most recent descriptive record
    -- YOUR CODE HERE
),

select
    -- TODO: Select hk_customer and cust_id from the Hub
    -- TODO: Select descriptive attributes (name, email, etc.) from the Satellite
    -- TODO: Map the different load_dates to first_seen_date and last_updated_date
    -- YOUR CODE HERE
from hub h
-- TODO: Left join latest_sat on hk_customer where row number is 1

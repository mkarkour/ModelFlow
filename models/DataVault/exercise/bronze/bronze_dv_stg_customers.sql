/* EXERCISE: Create a staging model for Data Vault customers.

   PURPOSE:
   Used to prepare raw customer records for ingestion into the Data Vault.
   Computes hk_customer (hash of cust_id) and hash_diff (fingerprint of all
   descriptive fields) needed by downstream structures. Feeds the Customer Hub
   for uniqueness enforcement and the Customer Satellite for change detection.

   HINTS:
   1. Select from {{ ref('raw_customers') }}
   2. Use the `hash_key` macro on ['cust_id'] to create 'hk_customer'.
   3. Use the `hash_diff` macro on descriptive fields (name, email, country, city, segment) to create 'hash_diff'.
   4. Include `load_date()` as 'load_date'.
   5. Explicitly cast `cust_id` to integer, and dates to date.
*/

with source as (
    -- TODO: Select all columns from {{ ref('raw_customers') }}
    -- YOUR CODE HERE
),

staged as (
    -- TODO: Cast cust_id and generate the hk_customer Hash Key
    -- TODO: Trim descriptive attributes and lowercase the email
    -- TODO: Cast timestamps to dates
    -- TODO: Generate the hash_diff for change detection
    -- TODO: Add load_date and record_source metadata
    -- YOUR CODE HERE
)

select
    -- TODO: Select all columns from the staged CTE
    -- YOUR CODE HERE
from staged

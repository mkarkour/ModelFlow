/* EXERCISE: Implement an SCD Type 2 dimension for customers.

   PURPOSE:
   Used to track historical versions of customer records for point-in-time
   analysis. Each row represents one version of a customer with valid_from /
   valid_to date ranges and an is_current flag. The fact table joins this
   dimension on customer_sk to retrieve the correct customer state at the time
   of each order.

   HINTS:
   1. Select from `bronze_ss_stg_customers`.
   2. You need to create simulated history for customers whose `created_at` != `updated_at`.
   3. Step 1: Create a CTE for the "original" versions (`created_at` < `updated_at`).
      - Their `valid_from` is `created_at`.
      - Their `valid_to` is `updated_at`.
      - `is_current` is false, `version` is 1.
   4. Step 2: Create a CTE for the "current" versions of those updated customers.
      - Their `valid_from` is `updated_at`.
      - Their `valid_to` is '9999-12-31' (cast properly).
      - `is_current` is true, `version` is 2.
   5. Step 3: Create a CTE for customers with no updates (`created_at` = `updated_at`).
      - Their `valid_from` is `created_at`.
      - Their `valid_to` is '9999-12-31'.
      - `is_current` is true, `version` is 1.
   6. Combine them with UNION ALL.
   7. Wrap the result and generate `customer_sk` using `{{ dbt_utils.generate_surrogate_key(['cust_id', 'valid_from']) }}`.
*/

with staged as (
    -- TODO: Select from bronze_ss_stg_customers
    -- YOUR CODE HERE
),

v1 as (
    -- TODO: Create "original" version (row at created_at) where created_at < updated_at
    -- YOUR CODE HERE
),

v2 as (
    -- TODO: Create "current" version (row at updated_at) where created_at < updated_at
    -- YOUR CODE HERE
),

v_only as (
    -- TODO: Customers with no update (single current row) where created_at = updated_at
    -- YOUR CODE HERE
),

unioned as (
    -- TODO: Combine v1, v2, and v_only using UNION ALL
    -- YOUR CODE HERE
)

select
    -- TODO: Generate surrogate key: {{ dbt_utils.generate_surrogate_key(['cust_id', 'valid_from']) }} as customer_sk
    -- TODO: Select all columns from unioned
    -- YOUR CODE HERE
from unioned

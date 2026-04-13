/* EXERCISE: Implement an SCD Type 2 dimension for customers.

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

-- YOUR CODE HERE

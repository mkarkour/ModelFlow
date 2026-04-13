-- =============================================================================
-- Singular Test: Custom Assertion (Exercise)
-- Purpose      : Write a SQL query that returns rows only when the assertion
--                FAILS. dbt will report the test as failed if any rows are
--                returned, and passed if the result is empty.
--
-- Template:
--   SELECT <columns that identify the violation>
--   FROM   {{ ref('your_model') }}
--   WHERE  <condition that should never be true>
--
-- Example — no order should have a negative gross_revenue:
--   SELECT order_id, gross_revenue
--   FROM   main_inmon_silver.fact_order_3nf
--   WHERE  gross_revenue < 0
-- =============================================================================

-- TODO: replace this with your assertion
SELECT 1 WHERE 1 = 0

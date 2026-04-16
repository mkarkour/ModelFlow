-- =============================================================================
-- Generic Test: Custom Check (Exercise)
-- Purpose      : Implement a reusable generic test that can be referenced
--                from any schema.yml file.
--
-- A generic test macro receives:
--   model       — the relation being tested (use {{ model }} in FROM)
--   column_name — the column declared in schema.yml (optional but conventional)
--   + any extra parameters you define
--
-- Usage (in schema.yml):
--   models:
--     - name: your_model
--       tests:
--         - custom_check:
--             column_name: your_column
--             # add your own parameters here
--
-- The test FAILS if any rows are returned.
-- =============================================================================

-- TODO: replace this with your test
{% test custom_check(model, column_name) %}

select {{ column_name }} from {{ model }} where {{ column_name }} = 'abc'

{% endtest %}
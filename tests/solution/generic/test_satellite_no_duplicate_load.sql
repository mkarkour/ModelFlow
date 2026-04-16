-- =============================================================================
-- Generic Test: Satellite No Duplicate Load (Data Vault)
-- Verifies that a satellite never has two rows sharing the same hash key and
-- load date. Duplicates indicate a broken idempotency contract.
--
-- Usage (schema.yml):
--   columns:
--     - name: hk_customer
--       data_tests:
--         - satellite_no_duplicate_load
-- =============================================================================

{% test satellite_no_duplicate_load(model, column_name) %}

select
    {{ column_name }},
    load_date,
    count(*) as duplicate_count
from {{ model }}
group by {{ column_name }}, load_date
having count(*) > 1

{% endtest %}

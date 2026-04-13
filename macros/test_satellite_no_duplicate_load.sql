-- =============================================================================
-- Custom Generic Test: Satellite No Duplicate Load
-- Architecture : Data Vault
-- Purpose      : Ensure that a satellite table never contains two records
--                with the same hash key and load date. Duplicate loads indicate
--                a broken idempotency contract in the loading process.
-- Usage (in schema.yml):
--   models:
--     - name: sat_customer_details
--       tests:
--         - satellite_no_duplicate_load:
--             hash_key_column: hk_customer
--             load_date_column: load_date
-- =============================================================================

{% test satellite_no_duplicate_load(model, hash_key_column, load_date_column) %}

select
    {{ hash_key_column }},
    {{ load_date_column }},
    count(*) as duplicate_count
from {{ model }}
group by {{ hash_key_column }}, {{ load_date_column }}
having count(*) > 1

{% endtest %}

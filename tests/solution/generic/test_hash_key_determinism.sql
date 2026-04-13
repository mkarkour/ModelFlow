-- =============================================================================
-- Custom Generic Test: Hash Key Determinism
-- Architecture : Data Vault
-- Purpose      : Verify that recomputing the hash key on the business key
--                column(s) always yields the same stored hash key value.
--                A failing test indicates non-deterministic hashing or
--                data corruption between staging and the Hub/Link.
-- Usage (in schema.yml):
--   columns:
--     - name: hk_customer
--       tests:
--         - hash_key_determinism:
--             business_key_columns: ['cust_id']
-- =============================================================================

{% test hash_key_determinism(model, column_name, business_key_columns) %}

with recomputed as (
    select
        {{ column_name }} as stored_hash,
        {{ hash_key(business_key_columns) }} as expected_hash
    from {{ model }}
)

select
    stored_hash,
    expected_hash
from recomputed
where stored_hash != expected_hash

{% endtest %}

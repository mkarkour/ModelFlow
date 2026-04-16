-- =============================================================================
-- Generic Test: Hash Key Determinism (Data Vault)
-- Verifies that recomputing MD5 on the business key always matches the stored
-- hash key. Any returned row indicates a corruption or a non-deterministic
-- hashing issue between staging and the Hub.
--
-- Usage (schema.yml):
--   columns:
--     - name: hk_customer
--       data_tests:
--         - hash_key_determinism:
--             business_key: cust_id
-- =============================================================================

{% test hash_key_determinism(model, column_name, business_key) %}

with recomputed as (
    select
        {{ column_name }}                                                       as stored_hash,
        lower(md5(coalesce(cast({{ business_key }} as varchar), '^^')))        as expected_hash
    from {{ model }}
)

select
    stored_hash,
    expected_hash
from recomputed
where stored_hash != expected_hash

{% endtest %}

-- =============================================================================
-- Singular Test: Hash Key Determinism (Data Vault)
-- Verifies that recomputing MD5 on the business key always matches the stored
-- hash key in hub_customer. Any returned row indicates a corruption or a
-- non-deterministic hashing issue between staging and the Hub.
-- =============================================================================

with recomputed as (
    select
        hk_customer                                                       as stored_hash,
        lower(md5(coalesce(cast(cust_id as varchar), '^^')))             as expected_hash
    from {{ ref('hub_customer') }}
)

select
    stored_hash,
    expected_hash
from recomputed
where stored_hash != expected_hash

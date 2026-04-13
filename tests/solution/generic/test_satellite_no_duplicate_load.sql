-- =============================================================================
-- Singular Test: Satellite No Duplicate Load (Data Vault)
-- Verifies that sat_customer_details never has two rows sharing the same
-- hash key and load date. Duplicates indicate a broken idempotency contract.
-- =============================================================================

select
    hk_customer,
    load_date,
    count(*) as duplicate_count
from {{ ref('sat_customer_details') }}
group by hk_customer, load_date
having count(*) > 1

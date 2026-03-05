-- =============================================================================
-- Inmon 3NF Silver: Customer Entity (3NF CDW)
-- Purpose : Normalized customer dimension in Third Normal Form.
--           Single source of truth — no duplicated attributes.
--           PK = cust_id (natural key, enforced via dbt tests).
-- =============================================================================
with staged as (
    select * from {{ ref('bronze_3nf_stg_customers') }}
)

select
    cust_id,               -- PK (natural key, no surrogate needed in 3NF CDW)
    cust_name,
    cust_email,
    cust_country,
    cust_city,
    cust_segment,
    created_at,
    updated_at,
    _loaded_at
from staged

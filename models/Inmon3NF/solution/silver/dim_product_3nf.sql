-- =============================================================================
-- Inmon 3NF Silver: Product Entity (3NF CDW)
-- Purpose : Normalized product entity in Third Normal Form.
--           PK = prod_id. No derived/calculated columns (those go to Gold).
-- =============================================================================
with staged as (
    select * from {{ ref('bronze_3nf_stg_products') }}
)

select
    prod_id,              -- PK
    product_name,
    category,
    subcategory,
    price,
    cost,
    sku,
    is_active,
    _loaded_at
from staged

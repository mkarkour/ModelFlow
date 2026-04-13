-- =============================================================================
-- Singular Test: Star Schema — No Orphan Surrogate Keys in Fact
-- Purpose : Verify that all surrogate keys in fact_sales resolve to valid
--           dimension records. Unlike Inmon (natural keys) and DV (hash keys),
--           Star Schema uses surrogate keys — making this check essential.
-- Expected result: 0 rows (all SKs resolve)
-- =============================================================================
-- Orphan customer surrogate keys
select
    'orphan_customer_sk'    as violation_type,
    cast(f.order_id as varchar) as order_id,
    f.customer_sk           as offending_sk
from {{ ref('fact_sales') }} f
left join {{ ref('dim_customer_scd2') }} dc on f.customer_sk = dc.customer_sk
where dc.customer_sk is null

union all

-- Orphan product surrogate keys
select
    'orphan_product_sk'     as violation_type,
    cast(f.order_id as varchar) as order_id,
    f.product_sk            as offending_sk
from {{ ref('fact_sales') }} f
left join {{ ref('dim_product_scd2') }} dp on f.product_sk = dp.product_sk
where dp.product_sk is null

union all

-- Orphan date keys
select
    'orphan_date_key'       as violation_type,
    cast(f.order_id as varchar) as order_id,
    cast(f.order_date_key as varchar) as offending_sk
from {{ ref('fact_sales') }} f
left join {{ ref('dim_date') }} dd on f.order_date_key = dd.date_key
where dd.date_key is null

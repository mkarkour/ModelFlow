-- =============================================================================
-- Data Vault Silver: Hub Product
-- Purpose : Unique list of business keys (prod_id) and their first load date.
-- =============================================================================
with source as (
    select * from {{ ref('bronze_dv_stg_products') }}
),

hub_product as (
    select
        hk_product,
        prod_id,
        min(load_date) as load_date,
        min(record_source) as record_source
    from source
    group by 1, 2
)

select * from hub_product

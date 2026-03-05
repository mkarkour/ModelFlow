-- =============================================================================
-- Inmon 3NF Bronze: Products Staging
-- Purpose : Cleanse and standardize product data for CDW 3NF loading.
-- Source  : seeds.raw_products
-- =============================================================================
with source as (
    select * from {{ ref('raw_products') }}
),

staged as (
    select
        cast(prod_id as integer)    as prod_id,
        trim(product_name)          as product_name,
        trim(category)              as category,
        trim(subcategory)           as subcategory,
        cast(price as double)       as price,
        cast(cost as double)        as cost,
        upper(trim(sku))            as sku,
        cast(is_active as boolean)  as is_active,
        {{ load_date() }}   as _loaded_at
    from source
)

select * from staged

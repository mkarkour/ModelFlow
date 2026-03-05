-- =============================================================================
-- Data Vault Bronze: Products Staging
-- Purpose : Clean, cast, and compute Hash Keys for downstream Raw Vault loading.
-- Source  : seeds.raw_products
-- =============================================================================
with source as (
    select * from {{ ref('raw_products') }}
),

staged as (
    select
        -- ── Business Key & Hash Key
        cast(prod_id as integer)                    as prod_id,
        {{ hash_key(['prod_id']) }}                 as hk_product,

        -- ── Descriptive Attributes
        trim(product_name)                          as product_name,
        trim(category)                              as category,
        trim(subcategory)                           as subcategory,
        cast(price as double)                       as price,
        cast(cost as double)                        as cost,
        upper(trim(sku))                            as sku,
        cast(is_active as boolean)                  as is_active,

        -- ── Hash Diff
        {{ hash_diff(['product_name', 'category', 'price', 'sku', 'is_active']) }} as hash_diff,

        -- ── Metadata
        {{ load_date() }}                           as load_date,
        'seeds.raw_products'                        as record_source

    from source
)

select * from staged

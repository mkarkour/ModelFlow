-- =============================================================================
-- Data Vault Silver: Sat Product Details
-- Purpose : Descriptive attributes for Products with change detection.
-- =============================================================================
with source as (
    select * from {{ ref('bronze_dv_stg_products') }}
),

latest_records as (
    select
        hk_product,
        hash_diff,
        product_name,
        category,
        subcategory,
        price,
        cost,
        sku,
        is_active,
        load_date,
        record_source,
        row_number() over (partition by hk_product order by load_date desc) as row_num
    from source
)

select
    hk_product,
    hash_diff,
    product_name,
    category,
    subcategory,
    price,
    cost,
    sku,
    is_active,
    load_date,
    record_source
from latest_records
where row_num = 1

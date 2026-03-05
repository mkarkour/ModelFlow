-- =============================================================================
-- Star Schema Silver: Product Dimension (SCD Type 2)
-- Purpose : Track price and attribute changes for products over time.
--           In a real pipeline, incremental loads would detect changes.
--           Here we simulate a single version per product (no history yet).
-- =============================================================================
with staged as (
    select * from {{ ref('bronze_ss_stg_products') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['prod_id', "'2020-01-01'"]) }} as product_sk,
    prod_id,
    product_name,
    category,
    subcategory,
    price,
    cost,
    sku,
    is_active,
    cast('2020-01-01' as date)      as valid_from,
    cast('9999-12-31' as date)      as valid_to,
    true                            as is_current,
    1                               as version
from staged

-- =============================================================================
-- Data Vault Silver: Sat Order Details
-- Purpose : Descriptive attributes for Orders (Point in Time context).
-- =============================================================================
with source_data as (
    select * from {{ ref('bronze_dv_stg_orders') }}
),

latest_records as (
    select
        hk_order_link,
        hash_diff,
        order_date,
        quantity,
        discount_pct,
        order_status,
        channel,
        payment_method,
        load_date,
        record_source,
        row_number() over (partition by hk_order_link order by load_date desc) as row_num
    from source_data
)

select
    hk_order_link,
    hash_diff,
    order_date,
    quantity,
    discount_pct,
    order_status,
    channel,
    payment_method,
    load_date,
    record_source
from latest_records
where row_num = 1

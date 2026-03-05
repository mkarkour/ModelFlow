-- =============================================================================
-- Inmon 3NF Bronze: Orders Staging
-- Purpose : Cleanse and standardize order data for CDW 3NF loading.
-- Source  : seeds.raw_orders
-- =============================================================================
with source as (
    select * from {{ ref('raw_orders') }}
),

staged as (
    select
        cast(order_id as integer)       as order_id,
        cast(cust_id as integer)        as cust_id,
        cast(prod_id as integer)        as prod_id,
        cast(order_date as date)        as order_date,
        cast(quantity as integer)       as quantity,
        cast(discount_pct as double)    as discount_pct,
        trim(status)                    as order_status,
        trim(channel)                   as channel,
        trim(payment_method)            as payment_method,
        {{ load_date() }}       as _loaded_at
    from source
)

select * from staged

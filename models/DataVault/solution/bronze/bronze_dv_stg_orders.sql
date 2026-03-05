-- =============================================================================
-- Data Vault Bronze: Orders Staging
-- Purpose : Clean, cast, and compute Hash Keys for downstream Raw Vault loading.
--           Orders produce THREE hash keys: hk_order, hk_customer, hk_product.
-- Source  : seeds.raw_orders
-- =============================================================================
with source as (
    select * from {{ ref('raw_orders') }}
),

staged as (
    select
        -- ── Business Keys & Hash Keys
        cast(order_id as integer)                               as order_id,
        cast(cust_id as integer)                                as cust_id,
        cast(prod_id as integer)                                as prod_id,

        {{ hash_key(['order_id']) }}                            as hk_order,
        {{ hash_key(['cust_id']) }}                             as hk_customer,  -- FK to Hub Customer
        {{ hash_key(['prod_id']) }}                             as hk_product,   -- FK to Hub Product

        -- ── Link-level Hash Key (composite)
        {{ hash_key(['order_id', 'cust_id', 'prod_id']) }}      as hk_order_link,

        -- ── Descriptive Attributes
        cast(order_date as date)                                as order_date,
        cast(quantity as integer)                               as quantity,
        cast(discount_pct as double)                            as discount_pct,
        trim(status)                                            as order_status,
        trim(channel)                                           as channel,
        trim(payment_method)                                    as payment_method,

        -- ── Hash Diff (satellite)
        {{ hash_diff(['order_date', 'quantity', 'discount_pct', 'status', 'channel', 'payment_method']) }} as hash_diff,

        -- ── Metadata
        {{ load_date() }}                                       as load_date,
        'seeds.raw_orders'                                      as record_source

    from source
)

select * from staged

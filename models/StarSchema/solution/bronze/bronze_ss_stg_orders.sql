-- =============================================================================
-- Star Schema Bronze: Orders Staging
-- Purpose : Cleanse and prepare order data for the fact table.
-- Source  : seeds.raw_orders + seeds.raw_products (to denormalize price at order time)
-- =============================================================================
with orders as (
    select * from {{ ref('raw_orders') }}
),

products as (
    select prod_id, price, cost from {{ ref('raw_products') }}
),

staged as (
    select
        cast(o.order_id as integer)     as order_id,
        cast(o.cust_id as integer)      as cust_id,
        cast(o.prod_id as integer)      as prod_id,
        cast(o.order_date as date)      as order_date,
        cast(o.quantity as integer)     as quantity,
        cast(o.discount_pct as double)  as discount_pct,
        trim(o.status)                  as order_status,
        trim(o.channel)                 as channel,
        trim(o.payment_method)          as payment_method,

        -- ── Denormalize unit price & cost at time of order (for fact grain)
        cast(p.price as double)         as unit_price,
        cast(p.cost as double)          as unit_cost,

        -- ── Derived financial metrics
        round(
            cast(o.quantity as double) * p.price * (1 - o.discount_pct / 100.0)
        , 2)                            as gross_revenue,

        round(
            cast(o.quantity as double) * p.cost
        , 2)                            as total_cost,

        {{ load_date() }}       as _loaded_at
    from orders o
    left join products p on o.prod_id = p.prod_id
)

select * from staged

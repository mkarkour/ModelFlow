-- =============================================================================
-- Star Schema Silver: Sales Fact Table
-- Purpose : Grain = one row per order line. Joins to dimension surrogate keys.
--           Optimized for BI query patterns with denormalized metrics.
-- =============================================================================
with orders as (
    select * from {{ ref('bronze_ss_stg_orders') }}
),

dim_customer as (
    select customer_sk, cust_id
    from {{ ref('dim_customer_scd2') }}
    where is_current = true   -- use current version for SK lookup
),

dim_product as (
    select product_sk, prod_id
    from {{ ref('dim_product_scd2') }}
    where is_current = true
),

dim_date as (
    select date_key, full_date
    from {{ ref('dim_date') }}
)

select
    -- ── Surrogate Keys (FKs to dimensions)
    dc.customer_sk,
    dp.product_sk,
    dd.date_key                                     as order_date_key,

    -- ── Degenerate Dimension (natural key kept on fact)
    o.order_id,

    -- ── Measures
    o.quantity,
    o.unit_price,
    o.unit_cost,
    o.discount_pct,
    o.gross_revenue,
    o.total_cost,
    round(o.gross_revenue - o.total_cost, 2)        as gross_margin,
    round(
        case when o.gross_revenue > 0
             then (o.gross_revenue - o.total_cost) / o.gross_revenue * 100
             else 0
        end
    , 2)                                            as gross_margin_pct,

    -- ── Semi-additive/non-additive attributes
    o.order_status,
    o.channel,
    o.payment_method,

    o._loaded_at
from orders o
left join dim_customer dc on o.cust_id = dc.cust_id
left join dim_product  dp on o.prod_id = dp.prod_id
left join dim_date     dd on o.order_date = dd.full_date

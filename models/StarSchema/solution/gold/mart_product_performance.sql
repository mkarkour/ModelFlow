-- =============================================================================
-- Star Schema Gold: Product Performance Mart
-- Purpose : Aggregated product-level revenue, volume, and margin metrics.
--           Optimized for product analytics and category management dashboards.
-- =============================================================================
with fact as (
    select * from {{ ref('fact_sales') }}
    where order_status != 'Cancelled'
),

dim_product as (
    select * from {{ ref('dim_product_scd2') }}
    where is_current = true
),

dim_date as (
    select * from {{ ref('dim_date') }}
)

select
    -- ── Product Attributes
    p.prod_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.sku,
    p.price         as current_list_price,
    p.cost          as current_unit_cost,

    -- ── Aggregated by Month
    d.year,
    d.month_num,
    d.month_name,
    d.year_month,

    -- ── Volume
    count(f.order_id)               as total_orders,
    sum(f.quantity)                 as total_units_sold,

    -- ── Revenue
    round(sum(f.gross_revenue), 2)  as total_gross_revenue,
    round(sum(f.total_cost), 2)     as total_cost,
    round(sum(f.gross_margin), 2)   as total_gross_margin,
    round(
        case when sum(f.gross_revenue) > 0
             then sum(f.gross_margin) / sum(f.gross_revenue) * 100
             else 0 end
    , 2)                            as gross_margin_pct,
    round(avg(f.gross_revenue), 2)  as avg_order_revenue,

    -- ── Channel Mix
    count(case when f.channel = 'Web'       then 1 end) as web_orders,
    count(case when f.channel = 'Mobile'    then 1 end) as mobile_orders,
    count(case when f.channel = 'In-Store'  then 1 end) as instore_orders,
    count(case when f.channel = 'Partner'   then 1 end) as partner_orders

from fact f
left join dim_product p on f.product_sk   = p.product_sk
left join dim_date    d on f.order_date_key = d.date_key
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
order by d.year, d.month_num, total_gross_revenue desc

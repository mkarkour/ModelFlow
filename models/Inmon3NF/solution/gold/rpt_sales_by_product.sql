-- =============================================================================
-- Inmon 3NF Gold: Sales by Product Report
-- Purpose : Pre-aggregated product and category performance report.
-- =============================================================================
with fact as (
    select * from {{ ref('fact_order_3nf') }}
    where order_status != 'Cancelled'
),

products as (
    select * from {{ ref('dim_product_3nf') }}
)

select
    p.prod_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.sku,
    p.price                                         as list_price,

    -- ── Volume metrics
    count(f.order_id)                               as total_orders,
    sum(f.quantity)                                 as total_units_sold,

    -- ── Revenue metrics
    round(sum(f.gross_revenue), 2)                  as total_gross_revenue,
    round(sum(f.total_cost), 2)                     as total_cost,
    round(sum(f.gross_margin), 2)                   as total_gross_margin,
    round(
        case when sum(f.gross_revenue) > 0
             then sum(f.gross_margin) / sum(f.gross_revenue) * 100
             else 0 end
    , 2)                                            as gross_margin_pct,

    -- ── Date range
    min(f.order_date)                               as first_sale_date,
    max(f.order_date)                               as last_sale_date

from products p
left join fact f on p.prod_id = f.prod_id
group by 1, 2, 3, 4, 5, 6
having count(f.order_id) > 0
order by total_gross_revenue desc

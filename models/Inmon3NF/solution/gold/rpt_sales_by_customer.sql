-- =============================================================================
-- Inmon 3NF Gold: Sales by Customer Report
-- Purpose : Pre-aggregated reporting view for customer revenue performance.
--           Built from the normalized CDW silver entities.
-- =============================================================================
with fact as (
    select * from {{ ref('fact_order_3nf') }}
    where order_status != 'Cancelled'
),

customers as (
    select * from {{ ref('dim_customer_3nf') }}
)

select
    c.cust_id,
    c.cust_name,
    c.cust_country,
    c.cust_segment,
    c.cust_city,

    -- ── Order metrics
    count(f.order_id)                                   as total_orders,
    sum(f.quantity)                                     as total_units_sold,

    -- ── Revenue metrics
    round(sum(f.gross_revenue), 2)                      as total_gross_revenue,
    round(sum(f.total_cost), 2)                         as total_cost,
    round(sum(f.gross_margin), 2)                       as total_gross_margin,
    round(avg(f.gross_revenue), 2)                      as avg_order_value,

    -- ── Date metrics
    min(f.order_date)                                   as first_order_date,
    max(f.order_date)                                   as last_order_date,
    datediff('day', min(f.order_date), max(f.order_date)) as customer_lifetime_days

from customers c
left join fact f on c.cust_id = f.cust_id
group by 1, 2, 3, 4, 5
having count(f.order_id) > 0
order by total_gross_revenue desc

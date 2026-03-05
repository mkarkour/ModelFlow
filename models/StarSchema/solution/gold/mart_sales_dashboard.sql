-- =============================================================================
-- Star Schema Gold: Sales Dashboard Mart
-- Purpose : Fully denormalized mart optimized for BI tool consumption.
--           Combines fact + all dimensions into a single wide table.
--           Avoids joins at query time (typical star schema BI pattern).
-- =============================================================================
with fact as (
    select * from {{ ref('fact_sales') }}
    where order_status != 'Cancelled'
),

dim_customer as (
    select * from {{ ref('dim_customer_scd2') }}
    where is_current = true
),

dim_product as (
    select * from {{ ref('dim_product_scd2') }}
    where is_current = true
),

dim_date as (
    select * from {{ ref('dim_date') }}
)

select
    -- ── Order Identifiers
    f.order_id,

    -- ── Customer Attributes (from SCD2 current snapshot)
    c.cust_id,
    c.cust_name,
    c.cust_email,
    c.cust_country,
    c.cust_city,
    c.cust_segment,

    -- ── Product Attributes
    p.prod_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.sku,

    -- ── Date Attributes (from Date Dimension)
    d.full_date         as order_date,
    d.year,
    d.quarter,
    d.month_num,
    d.month_name,
    d.week_of_year,
    d.day_name,
    d.is_weekend,
    d.quarter_label,
    d.year_month,

    -- ── Transaction Details
    f.channel,
    f.payment_method,
    f.order_status,

    -- ── Measures
    f.quantity,
    f.unit_price,
    f.unit_cost,
    f.discount_pct,
    f.gross_revenue,
    f.total_cost,
    f.gross_margin,
    f.gross_margin_pct

from fact f
left join dim_customer c on f.customer_sk = c.customer_sk
left join dim_product  p on f.product_sk  = p.product_sk
left join dim_date     d on f.order_date_key = d.date_key

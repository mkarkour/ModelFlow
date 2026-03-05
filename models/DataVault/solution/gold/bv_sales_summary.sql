-- =============================================================================
-- Data Vault Gold: Business Vault — Sales Summary
-- Purpose : Aggregated sales metrics assembled from Raw Vault structures.
--           Demonstrates the Business Vault pattern: derived business metrics
--           computed on top of the Raw Vault without modifying it.
-- =============================================================================
with link as (
    select * from {{ ref('link_order') }}
),

sat_order as (
    -- Latest satellite row per order hash key
    select * from (
        select
            *,
            row_number() over (
                partition by hk_order_link
                order by load_date desc
            ) as rn
        from {{ ref('sat_order_details') }}
    )
    where rn = 1
),

sat_customer as (
    select * from (
        select
            *,
            row_number() over (
                partition by hk_customer
                order by load_date desc
            ) as rn
        from {{ ref('sat_customer_details') }}
    )
    where rn = 1
),

sat_product as (
    select * from (
        select
            *,
            row_number() over (
                partition by hk_product
                order by load_date desc
            ) as rn
        from {{ ref('sat_product_details') }}
    )
    where rn = 1
),

assembled as (
    select
        l.order_id,
        l.hk_customer,
        l.hk_product,
        sc.cust_name,
        sc.cust_country,
        sc.cust_segment,
        sp.product_name,
        sp.category,
        sp.price,
        sp.cost,
        so.order_date,
        so.quantity,
        so.discount_pct,
        so.order_status,
        so.channel,
        so.payment_method,
        round(so.quantity * sp.price * (1 - so.discount_pct / 100.0), 2) as gross_revenue,
        round(so.quantity * sp.cost, 2)                                   as total_cost
    from link l
    left join sat_order    so on l.hk_order_link = so.hk_order_link
    left join sat_customer sc on l.hk_customer = sc.hk_customer
    left join sat_product  sp on l.hk_product  = sp.hk_product
)

select * from assembled

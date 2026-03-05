-- =============================================================================
-- Inmon 3NF Silver: Order Fact (3NF CDW)
-- Purpose : Normalized order fact table in Third Normal Form.
--           Uses NATURAL KEYS (cust_id, prod_id) as FKs — not surrogates.
--           Non-redundant: no customer/product attributes stored here.
--           Demonstrates hard FK enforcement via dbt relationship tests.
-- =============================================================================
with staged as (
    select * from {{ ref('bronze_3nf_stg_orders') }}
),

-- Enrich with product price to compute revenue (joining to 3NF product entity)
products as (
    select prod_id, price, cost from {{ ref('dim_product_3nf') }}
)

select
    o.order_id,                        -- PK
    o.cust_id,                         -- FK → dim_customer_3nf (hard constraint)
    o.prod_id,                         -- FK → dim_product_3nf  (hard constraint)
    o.order_date,
    o.quantity,
    o.discount_pct,
    o.order_status,
    o.channel,
    o.payment_method,

    -- ── Computed measures (3NF allows derivable columns in fact)
    p.price                                                         as unit_price,
    p.cost                                                          as unit_cost,
    round(o.quantity * p.price * (1 - o.discount_pct / 100.0), 2) as gross_revenue,
    round(o.quantity * p.cost, 2)                                   as total_cost,
    round(
        o.quantity * p.price * (1 - o.discount_pct / 100.0)
        - o.quantity * p.cost
    , 2)                                                            as gross_margin,

    o._loaded_at
from staged o
left join products p on o.prod_id = p.prod_id

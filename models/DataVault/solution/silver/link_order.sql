-- =============================================================================
-- Data Vault Silver: Link Order
-- Purpose : Relationship between Customer, Product, and Order.
-- =============================================================================
with source_data as (
    select * from {{ ref('bronze_dv_stg_orders') }}
),

link_order as (
    select
        hk_order_link,
        hk_order,
        hk_customer,
        hk_product,
        order_id,
        min(load_date) as load_date,
        min(record_source) as record_source
    from source_data
    group by 1, 2, 3, 4, 5
)

select * from link_order

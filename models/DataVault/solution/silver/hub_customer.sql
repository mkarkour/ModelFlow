-- =============================================================================
-- Data Vault Silver: Hub Customer
-- Purpose : Unique list of business keys (cust_id) and their first load date.
-- =============================================================================
with source as (
    select * from {{ ref('bronze_dv_stg_customers') }}
),

hub_customer as (
    select
        hk_customer,
        cust_id,
        min(load_date) as load_date,
        min(record_source) as record_source
    from source
    group by 1, 2
)

select * from hub_customer

-- =============================================================================
-- Data Vault Silver: Sat Customer Details
-- Purpose : Descriptive attributes for Customers with change detection.
-- =============================================================================
with source as (
    select * from {{ ref('bronze_dv_stg_customers') }}
),

latest_records as (
    select
        hk_customer,
        hash_diff,
        cust_name,
        cust_email,
        cust_country,
        cust_city,
        cust_segment,
        load_date,
        record_source,
        row_number() over (partition by hk_customer order by load_date desc) as row_num
    from source
)

select
    hk_customer,
    hash_diff,
    cust_name,
    cust_email,
    cust_country,
    cust_city,
    cust_segment,
    load_date,
    record_source
from latest_records
where row_num = 1

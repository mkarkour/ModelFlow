-- =============================================================================
-- Star Schema Bronze: Customers Staging
-- Purpose : Cleanse and prepare customer data for SCD2 dimension loading.
-- Source  : seeds.raw_customers
-- =============================================================================
with source as (
    select * from {{ ref('raw_customers') }}
),

staged as (
    select
        cast(cust_id as integer)    as cust_id,
        trim(name)                  as cust_name,
        lower(trim(email))          as cust_email,
        trim(country)               as cust_country,
        trim(city)                  as cust_city,
        trim(segment)               as cust_segment,
        cast(created_at as date)    as created_at,
        cast(updated_at as date)    as updated_at,
        {{ load_date() }}   as _loaded_at
    from source
)

select * from staged

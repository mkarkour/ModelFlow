-- =============================================================================
-- Data Vault Bronze: Customers Staging
-- Purpose : Clean, cast, and compute Hash Keys for downstream Raw Vault loading.
-- Source  : seeds.raw_customers
-- =============================================================================
with source as (
    select * from {{ ref('raw_customers') }}
),

staged as (
    select
        -- ── Business Key & Hash Key
        cast(cust_id as integer)                    as cust_id,
        {{ hash_key(['cust_id']) }}                 as hk_customer,

        -- ── Descriptive Attributes
        trim(name)                                  as cust_name,
        lower(trim(email))                          as cust_email,
        trim(country)                               as cust_country,
        trim(city)                                  as cust_city,
        trim(segment)                               as cust_segment,

        -- ── Dates
        cast(created_at as date)                    as created_at,
        cast(updated_at as date)                    as updated_at,

        -- ── Hash Diff (to detect satellite changes)
        {{ hash_diff(['name', 'email', 'country', 'city', 'segment']) }} as hash_diff,

        -- ── Metadata
        {{ load_date() }}                           as load_date,
        'seeds.raw_customers'                       as record_source

    from source
)

select * from staged

-- =============================================================================
-- Star Schema Silver: Customer Dimension (SCD Type 2)
-- Purpose : Slowly Changing Dimension tracking the full history of customer
--           attribute changes. Each changed version = a new row.
-- SCD2 columns: customer_sk (surrogate PK), valid_from, valid_to, is_current
--
-- Note: With static seed data we simulate SCD2 by treating created_at as the
-- initial version and updated_at as a potential change date, generating two
-- rows for customers whose updated_at differs from created_at.
-- =============================================================================
with staged as (
    select * from {{ ref('bronze_ss_stg_customers') }}
),

-- Initial version (row at created_at)
v1 as (
    select
        cust_id,
        cust_name,
        cust_email,
        cust_country,
        cust_city,
        cust_segment,
        created_at  as valid_from,
        updated_at  as valid_to,    -- will be superseded by v2 if changed
        false       as is_current,
        1           as version
    from staged
    where created_at < updated_at  -- has a subsequent update
),

-- Current version (row at updated_at — simulated attribute change)
v2 as (
    select
        cust_id,
        cust_name,
        cust_email,
        cust_country,
        cust_city,
        cust_segment,
        updated_at              as valid_from,
        cast('9999-12-31' as date) as valid_to,
        true                    as is_current,
        2                       as version
    from staged
    where created_at < updated_at
),

-- Customers with no update (single current row)
v_only as (
    select
        cust_id,
        cust_name,
        cust_email,
        cust_country,
        cust_city,
        cust_segment,
        created_at                  as valid_from,
        cast('9999-12-31' as date)  as valid_to,
        true                        as is_current,
        1                           as version
    from staged
    where created_at = updated_at
),

unioned as (
    select * from v1
    union all
    select * from v2
    union all
    select * from v_only
)

select
    {{ dbt_utils.generate_surrogate_key(['cust_id', 'valid_from']) }} as customer_sk,
    cust_id,
    cust_name,
    cust_email,
    cust_country,
    cust_city,
    cust_segment,
    valid_from,
    valid_to,
    is_current,
    version
from unioned

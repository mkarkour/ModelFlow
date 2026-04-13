-- =============================================================================
-- Bonus A — Data Vault Snapshot: Satellite Customer Details
-- Strategy : check — compares descriptive columns to detect attribute changes.
-- Purpose  : Capture historical versions of customer attributes over time,
--            complementing the satellite's built-in hash_diff mechanism with
--            dbt-native SCD2 tracking via dbt_valid_from / dbt_valid_to.
-- =============================================================================

{% snapshot snap_dv_sat_customer %}

{{
    config(
        target_schema='dv_snapshots',
        unique_key='hk_customer',
        strategy='check',
        check_cols=['cust_name', 'cust_email', 'cust_country', 'cust_city', 'cust_segment']
    )
}}

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
from {{ ref('sat_customer_details') }}

{% endsnapshot %}

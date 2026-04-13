-- =============================================================================
-- EXERCISE: Data Vault Snapshot - Satellite Customer Details
--
-- HINTS:
-- 1. Create a snapshot block named `snap_dv_sat_customer`.
-- 2. Configure it with:
--    - target_schema: 'dv_snapshots'
--    - unique_key: 'hk_customer'
--    - strategy: 'check'
--    - check_cols: ['cust_name', 'cust_email', 'cust_country', 'cust_city', 'cust_segment']
-- 3. Select all columns from the `sat_customer_details` model.
-- =============================================================================

-- YOUR CODE HERE
-- TODO:
-- 1. Configure snapshot settings
-- 2. Select from ref('sat_customer_details')

{#
{% snapshot snap_dv_sat_customer %}

{{
    config()
}}

{% endsnapshot %}
#}

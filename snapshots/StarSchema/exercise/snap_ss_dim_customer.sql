-- =============================================================================
-- EXERCISE: Star Schema Snapshot - Customer Dimension (SCD2)
--
-- HINTS:
-- 1. Create a snapshot block named `snap_ss_dim_customer`.
-- 2. Configure it with:
--    - target_schema: 'ss_snapshots'
--    - unique_key: 'customer_sk'
--    - strategy: 'timestamp'
--    - updated_at: 'valid_from'
-- 3. Select all columns from the `dim_customer_scd2` model.
-- =============================================================================

-- YOUR CODE HERE
-- TODO: 
-- 1. Configure snapshot settings
-- 2. Select from ref('dim_customer_scd2')

{#
{% snapshot snap_ss_dim_customer %}

{{
    config()
}}

{% endsnapshot %}
#}

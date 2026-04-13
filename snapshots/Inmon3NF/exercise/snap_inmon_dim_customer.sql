-- =============================================================================
-- EXERCISE: Inmon 3NF Snapshot - Customer Dimension
--
-- HINTS:
-- 1. Create a snapshot block named `snap_inmon_dim_customer`.
-- 2. Configure it with:
--    - target_schema: 'inmon_snapshots'
--    - unique_key: 'cust_id'
--    - strategy: 'timestamp'
--    - updated_at: 'updated_at'
-- 3. Select all columns from the `dim_customer_3nf` model.
-- =============================================================================

-- YOUR CODE HERE
-- TODO:
-- 1. Configure snapshot settings
-- 2. Select from ref('dim_customer_3nf')

{#
{% snapshot snap_inmon_dim_customer %}

{{
    config()
}}

{% endsnapshot %}
#}

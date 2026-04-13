-- =============================================================================
-- Bonus A — Inmon 3NF Snapshot: Customer Dimension
-- Strategy : timestamp — uses the updated_at column to detect changes.
-- Purpose  : Track historical versions of the 3NF customer entity. In Inmon
--            architecture, dimensions are updated in-place. This snapshot adds
--            a historical audit trail that the methodology natively lacks.
-- =============================================================================

{% snapshot snap_inmon_dim_customer %}

{{
    config(
        target_schema='inmon_snapshots',
        unique_key='cust_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    cust_id,
    cust_name,
    cust_email,
    cust_country,
    cust_city,
    cust_segment,
    created_at,
    updated_at,
    _loaded_at
from {{ ref('dim_customer_3nf') }}

{% endsnapshot %}

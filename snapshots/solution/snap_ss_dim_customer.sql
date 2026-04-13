-- =============================================================================
-- Bonus A — Star Schema Snapshot: Customer Dimension (SCD2)
-- Strategy : timestamp — uses valid_from as the change indicator.
-- Purpose  : Track changes to the SCD2 customer dimension over time. While the
--            model already implements SCD2 logic manually, this snapshot
--            demonstrates how dbt's native snapshot mechanism can serve as an
--            independent audit layer on top of an existing SCD2 implementation.
-- =============================================================================

{% snapshot snap_ss_dim_customer %}

{{
    config(
        target_schema='ss_snapshots',
        unique_key='customer_sk',
        strategy='timestamp',
        updated_at='valid_from'
    )
}}

select
    customer_sk,
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
from {{ ref('dim_customer_scd2') }}

{% endsnapshot %}

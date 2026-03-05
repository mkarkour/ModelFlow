-- =============================================================================
-- Data Vault Gold: Business Vault — Latest Customer View
-- Purpose : Point-in-time view joining Hub + most recent Satellite snapshot.
--           Provides a "current state" view over the Raw Vault for consumers.
-- =============================================================================
with hub as (
    select * from {{ ref('hub_customer') }}
),

sat as (
    select * from {{ ref('sat_customer_details') }}
),

-- Latest satellite row per hub key
latest_sat as (
    select
        *,
        row_number() over (
            partition by hk_customer
            order by load_date desc
        ) as rn
    from sat
)

select
    h.hk_customer,
    h.cust_id,
    s.cust_name,
    s.cust_email,
    s.cust_country,
    s.cust_city,
    s.cust_segment,
    h.load_date         as first_seen_date,
    s.load_date         as last_updated_date,
    h.record_source
from hub h
left join latest_sat s
    on h.hk_customer = s.hk_customer
    and s.rn = 1

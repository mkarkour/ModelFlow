-- =============================================================================
-- Singular Test: Data Vault — No Orphan Link Orders
-- Purpose : Verify that every order in link_order has a matching customer
--           in hub_customer (soft hash-based referential integrity).
--           In Data Vault, this is a "soft" constraint validated via tests,
--           NOT enforced by database-level FK constraints.
-- Expected result: 0 rows (no orphans)
-- =============================================================================
select
    l.hk_order_link,
    l.hk_customer,
    l.order_id
from {{ ref('link_order') }} l
left join {{ ref('hub_customer') }} hc
    on l.hk_customer = hc.hk_customer
where hc.hk_customer is null

-- =============================================================================
-- Singular Test: Inmon 3NF — Referential Integrity
-- Purpose : Verify that fact_order_3nf has no orders referencing customers
--           or products that don't exist in the 3NF CDW dimension tables.
--           In Inmon 3NF these are HARD constraints — violations indicate
--           a fundamental data integrity failure.
-- Expected result: 0 rows (no orphan FKs)
-- =============================================================================
-- Check orphan customer FKs
select
    'orphan_customer_fk'    as violation_type,
    cast(f.order_id as varchar) as order_id,
    cast(f.cust_id as varchar)  as offending_key
from {{ ref('fact_order_3nf') }} f
left join {{ ref('dim_customer_3nf') }} c on f.cust_id = c.cust_id
where c.cust_id is null

union all

-- Check orphan product FKs
select
    'orphan_product_fk'     as violation_type,
    cast(f.order_id as varchar) as order_id,
    cast(f.prod_id as varchar)  as offending_key
from {{ ref('fact_order_3nf') }} f
left join {{ ref('dim_product_3nf') }} p on f.prod_id = p.prod_id
where p.prod_id is null

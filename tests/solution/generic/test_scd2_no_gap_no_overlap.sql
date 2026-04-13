-- =============================================================================
-- Singular Test: SCD2 No Gap No Overlap (Star Schema)
-- Verifies that dim_customer_scd2 validity ranges are continuous and
-- non-overlapping per customer. Any returned row is a violation:
--   gap     → valid_to of version N < valid_from of version N+1
--   overlap → valid_to of version N > valid_from of version N+1
-- =============================================================================

with ordered_versions as (
    select
        cust_id,
        valid_from,
        valid_to,
        lead(valid_from) over (
            partition by cust_id
            order by valid_from
        ) as next_valid_from
    from {{ ref('dim_customer_scd2') }}
),

scd_gaps as (
    select
        cust_id,
        valid_to     as current_valid_to,
        next_valid_from,
        'gap'        as violation_type
    from ordered_versions
    where next_valid_from is not null
      and valid_to < next_valid_from
),

scd_overlaps as (
    select
        cust_id,
        valid_to     as current_valid_to,
        next_valid_from,
        'overlap'    as violation_type
    from ordered_versions
    where next_valid_from is not null
      and valid_to > next_valid_from
)

select * from scd_gaps
union all
select * from scd_overlaps

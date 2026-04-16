-- =============================================================================
-- Generic Test: SCD2 No Gap No Overlap (Star Schema)
-- Verifies that validity ranges are continuous and non-overlapping per business
-- key. Any returned row is a violation:
--   gap     → valid_to of version N < valid_from of version N+1
--   overlap → valid_to of version N > valid_from of version N+1
--
-- Usage (schema.yml):
--   columns:
--     - name: cust_id
--       data_tests:
--         - scd2_no_gap_no_overlap
-- =============================================================================

{% test scd2_no_gap_no_overlap(model, column_name) %}

with ordered_versions as (
    select
        {{ column_name }},
        valid_from,
        valid_to,
        lead(valid_from) over (
            partition by {{ column_name }}
            order by valid_from
        ) as next_valid_from
    from {{ model }}
),

scd_gaps as (
    select
        {{ column_name }},
        valid_to        as current_valid_to,
        next_valid_from,
        'gap'           as violation_type
    from ordered_versions
    where next_valid_from is not null
      and valid_to < next_valid_from
),

scd_overlaps as (
    select
        {{ column_name }},
        valid_to        as current_valid_to,
        next_valid_from,
        'overlap'       as violation_type
    from ordered_versions
    where next_valid_from is not null
      and valid_to > next_valid_from
)

select * from scd_gaps
union all
select * from scd_overlaps

{% endtest %}

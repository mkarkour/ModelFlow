-- =============================================================================
-- Custom Generic Test: SCD2 No Gap No Overlap
-- Architecture : Star Schema
-- Purpose      : Verify that SCD Type 2 dimension rows for each business key
--                have continuous, non-overlapping validity ranges.
--                - No gap   : the next version's valid_from equals the previous
--                             version's valid_to.
--                - No overlap: no two rows for the same business key have
--                             intersecting [valid_from, valid_to) ranges.
-- Usage (in schema.yml):
--   models:
--     - name: dim_customer_scd2
--       tests:
--         - scd2_no_gap_no_overlap:
--             business_key: cust_id
--             valid_from_col: valid_from
--             valid_to_col: valid_to
-- =============================================================================

{% test scd2_no_gap_no_overlap(model, business_key, valid_from_col, valid_to_col) %}

with ordered_versions as (
    select
        {{ business_key }},
        {{ valid_from_col }},
        {{ valid_to_col }},
        lead({{ valid_from_col }}) over (
            partition by {{ business_key }}
            order by {{ valid_from_col }}
        ) as next_valid_from
    from {{ model }}
),

gaps as (
    select
        {{ business_key }},
        {{ valid_to_col }}   as current_valid_to,
        next_valid_from,
        'gap' as violation_type
    from ordered_versions
    where next_valid_from is not null
      and {{ valid_to_col }} < next_valid_from
),

overlaps as (
    select
        {{ business_key }},
        {{ valid_to_col }}   as current_valid_to,
        next_valid_from,
        'overlap' as violation_type
    from ordered_versions
    where next_valid_from is not null
      and {{ valid_to_col }} > next_valid_from
)

select * from gaps
union all
select * from overlaps

{% endtest %}

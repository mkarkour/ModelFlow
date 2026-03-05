-- =============================================================================
-- Star Schema Silver: Date Dimension
-- Purpose : Calendar attributes dimension for time-based analysis.
--           Covers the full date range of order data (2 years back to today).
-- =============================================================================
with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2023-01-01' as date)",
        end_date="cast('2026-12-31' as date)"
    ) }}
),

dated as (
    select
        cast(date_day as date) as full_date
    from date_spine
)

select
    -- ── Primary Key
    cast(strftime(full_date, '%Y%m%d') as integer)  as date_key,
    full_date,

    -- ── Year / Quarter / Month
    year(full_date)                                  as year,
    quarter(full_date)                               as quarter,
    month(full_date)                                 as month_num,
    strftime(full_date, '%B')                        as month_name,
    strftime(full_date, '%b')                        as month_abbr,
    monthname(full_date)                             as month_name_alt,

    -- ── Week
    week(full_date)                                  as week_of_year,
    dayofweek(full_date)                             as day_of_week,  -- 0=Sun
    strftime(full_date, '%A')                        as day_name,
    strftime(full_date, '%a')                        as day_abbr,

    -- ── Day
    day(full_date)                                   as day_of_month,
    dayofyear(full_date)                             as day_of_year,

    -- ── Flags
    case when dayofweek(full_date) in (0, 6)
         then true else false end                    as is_weekend,

    -- ── Period labels
    'Q' || quarter(full_date) || ' ' || year(full_date) as quarter_label,
    year(full_date) || '-' || lpad(cast(month(full_date) as varchar), 2, '0')
                                                     as year_month

from dated
order by full_date

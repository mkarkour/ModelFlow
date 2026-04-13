/* EXERCISE: Create a Date Dimension table for the Star Schema.
   
   HINTS:
   1. Use the `dbt_utils.date_spine` macro to generate a series of dates.
      - set `datepart` to `'day'`
      - set `start_date` to `"cast('2023-01-01' as date)"`
      - set `end_date` to `"cast('2026-12-31' as date)"`
   2. Extract attributes from the base date, such as:
      - `date_key` (integer format, e.g., strftime to YYYYMMDD and cast to int)
      - `year`, `quarter`, `month_num`, `month_name`
      - `week_of_year`, `day_of_week`, `day_name`
      - `is_weekend` boolean flag
*/

with date_spine as (
    -- TODO: Use dbt_utils.date_spine macro to generate dates
    -- YOUR CODE HERE
),

dated as (
    -- TODO: Select and cast date_day as full_date
    -- YOUR CODE HERE
)

select
    -- ── Primary Key
    -- TODO: date_key
    -- TODO: full_date

    -- ── Year / Quarter / Month
    -- TODO: year, quarter, month_num, month_name, month_abbr, month_name_alt

    -- ── Week
    -- TODO: week_of_year, day_of_week, day_name, day_abbr

    -- ── Day
    -- TODO: day_of_month, day_of_year

    -- ── Flags
    -- TODO: is_weekend

    -- ── Period labels
    -- TODO: quarter_label, year_month

from dated
-- TODO: order by full_date

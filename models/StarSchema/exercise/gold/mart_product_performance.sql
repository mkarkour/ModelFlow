/* EXERCISE: Create the final product performance mart.
   
   HINTS:
   1. Select from the silver sales fact and filter out any cancelled orders.
   2. Join the fact table with the current silver product dimension and the date dimension.
   3. Select product attributes to group by (id, names, categories, and current prices/costs).
   4. Select time attributes to group by (year, month).
   5. Aggregate volume measures (count orders, sum units).
   6. Aggregate gross revenue, total cost, and gross margin. 
   7. Compute the aggregate gross margin percentage.
   8. Compute the average revenue per order.
   9. (Optional) Create conditional counts to show the channel mix.
*/

with fact as (
    -- TODO: Select from the silver sales fact and filter out any cancelled orders.
    -- YOUR CODE HERE
),

dim_product as (
    -- TODO: Select the current records from the silver product dimension.
    -- YOUR CODE HERE
),

dim_date as (
    -- TODO: Select from the date dimension.
    -- YOUR CODE HERE
)

select
    -- ── Product Attributes
    -- TODO: Select product attributes
    
    -- ── Aggregated by Month
    -- TODO: Select time attributes (year, month_num, month_name, year_month)

    -- ── Volume
    -- TODO: Aggregate volume measures (total orders, total units sold)

    -- ── Revenue
    -- TODO: Aggregate revenue and cost measures

    -- ── Channel Mix
    -- TODO: Add optional conditional counts for channel mix

from fact f
-- TODO: left join dimensions
-- TODO: group by product and date attributes

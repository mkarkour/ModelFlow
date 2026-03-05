/* EXERCISE: Create a staging model for Inmon 3NF orders.
   
   PATH: models/Inmon3NF/exercise/bronze/bronze_3nf_stg_orders.sql
   
   HINTS:
   1. Select from {{ ref('raw_orders') }}
   2. Join with {{ ref('raw_products') }} to get the current price/cost.
   3. Calculate gross_revenue (quantity * price).
*/

-- YOUR CODE HERE

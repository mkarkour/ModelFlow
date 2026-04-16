/* EXERCISE: Create a staging model for Star Schema orders.

   PURPOSE:
   Denormalized staging layer that enriches raw order rows with product price and
   cost by joining the products seed. Computes gross_revenue and total_cost so
   the downstream Star Schema fact table has pre-calculated financial measures
   ready to aggregate without further joins.

   HINTS:
   1. Select from the raw_orders seed and join with raw_products
   2. Denormalize unit price and cost onto each order row
   3. Cast columns to appropriate types (integer, double, date)
   4. Compute financial measures: gross revenue and total cost
   5. Clean and rename string columns where needed
*/

-- YOUR CODE HERE

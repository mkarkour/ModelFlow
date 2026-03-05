/* EXERCISE: Implement an SCD Type 2 dimension for customers.
   
   PATH: models/StarSchema/exercise/silver/dim_customer_scd2.sql
   
   HINTS:
   1. Use {{ dbt_utils.generate_surrogate_key(['cust_id', 'valid_from']) }} for the SK.
   2. Define valid_from (created_at).
   3. Define valid_to using lead(created_at) over partition by cust_id.
   4. Add an is_current flag where valid_to is null.
*/

-- YOUR CODE HERE

/* EXERCISE: Create a staging model for Star Schema customers.

   PURPOSE:
   First landing zone for raw customer data in the Star Schema pipeline.
   Standardizes types, cleans strings, and exposes temporal columns (created_at,
   updated_at) that drive SCD Type 2 history in the downstream customer dimension.

   HINTS:
   1. Select from the raw_customers seed
   2. Cast columns to appropriate types (integer, date)
   3. Clean string columns (trim whitespace, normalize email)
   4. Include temporal columns needed for SCD2 tracking downstream
*/

-- YOUR CODE HERE

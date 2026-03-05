/* EXERCISE: Create a staging model for Star Schema customers.
   
   PATH: models/StarSchema/exercise/bronze/bronze_ss_stg_customers.sql
   
   HINTS:
   1. Select from {{ ref('raw_customers') }}
   2. Cast cust_id to integer
   3. Ensure names and emails are trimmed
   4. Include created_at and updated_at for SCD2 tracking
*/

-- YOUR CODE HERE

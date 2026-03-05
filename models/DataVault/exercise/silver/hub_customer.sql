/* EXERCISE: Implement a Data Vault Hub for Customers.
   
   PATH: models/DataVault/exercise/silver/hub_customer.sql
   
   HINTS:
   1. Hubs store unique Business Keys.
   2. Select distinct hk_customer, cust_id, load_date from {{ ref('bronze_dv_stg_customers') }}.
   3. Ensure you only keep the first occurrence of a business key if there are duplicates.
*/

-- YOUR CODE HERE

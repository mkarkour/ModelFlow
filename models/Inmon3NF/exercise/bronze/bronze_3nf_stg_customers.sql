/* EXERCISE: Inmon 3NF Bronze - Staging Customers

   PURPOSE:
   First ingestion layer for customer data in the Inmon 3NF pipeline. Selects
   raw customer records from the seed and applies minimal cleansing (type casts,
   string trimming) before handing off to the normalized silver customer entity.
   No business logic here — only technical cleansing.

   HINTS:
   1. Select from the `raw_customers` seed.
   2. Cleanse string attributes: cast them to `varchar` and apply `trim()` to remove trailing whitespaces.
*/

-- YOUR CODE HERE

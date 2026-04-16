/* EXERCISE: Inmon 3NF Bronze - Staging Products

   PURPOSE:
   First ingestion layer for product data in the Inmon 3NF pipeline. Selects raw
   product records from the seed and trims string attributes before they populate
   the normalized silver product entity. No price logic or joins — pure technical
   cleansing only.

   HINTS:
   1. Select from the `raw_products` seed.
   2. Cleanse string attributes (e.g., product_name, category): cast them to `varchar` and apply `trim()` to remove trailing whitespaces.
*/

-- YOUR CODE HERE

/* EXERCISE: Inmon 3NF Bronze - Staging Orders

   PURPOSE:
   First ingestion layer for order data in the Inmon 3NF pipeline. Cleanses
   categorical string fields (status, channel, payment_method) before they reach
   the normalized fact table. No joins or measures computed here — the 3NF fact
   handles enrichment with a separate product join at the silver layer.

   HINTS:
   1. Select from the `raw_orders` seed.
   2. Cleanse string attributes (e.g., status, channel): cast them to `varchar` and apply `trim()` to remove whitespaces.
*/

-- YOUR CODE HERE

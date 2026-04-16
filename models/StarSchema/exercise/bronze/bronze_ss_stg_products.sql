/* EXERCISE: Create a staging model for Star Schema products.

   PURPOSE:
   Entry-point staging for raw product data in the Star Schema pipeline.
   Casts numeric and boolean fields to correct types, trims string columns,
   and exposes all product attributes required by the downstream SCD Type 2
   product dimension.

   HINTS:
   1. Select from the raw_products seed
   2. Cast columns to appropriate types (integer, double, boolean)
   3. Clean string columns (trim whitespace, normalize SKU)
   4. Include all product attributes needed by the SCD2 dimension
*/

-- YOUR CODE HERE

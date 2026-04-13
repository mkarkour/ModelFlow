/* EXERCISE: Star Schema Sales Fact Table.
   
   HINTS:
   1. Grain: one row per order. Base this on `bronze_ss_stg_orders`.
   2. Join `dim_customer_scd2` on `cust_id` AND `is_current = true` to get the latest `customer_sk`.
   3. Join `dim_product_scd2` on `prod_id` AND `is_current = true` to get `product_sk`.
   4. Join `dim_date` on `order_date = full_date` to get `date_key`.
   5. Select the surrogate keys from dimensions:
      - `customer_sk`, `product_sk`, `date_key` (alias as `order_date_key`).
   6. Retain the degenerate dimension: `order_id`.
   7. Bring over original and denormalized measures (`quantity`, `unit_price`, `unit_cost`, `discount_pct`, `gross_revenue`, `total_cost`).
   8. Calculate extra measures:
      - `gross_margin` = `gross_revenue` - `total_cost`
      - `gross_margin_pct` = safe division of `gross_margin` by `gross_revenue` * 100
   9. Include categorical attributes like `order_status`, `channel`, `payment_method`.
*/

-- YOUR CODE HERE

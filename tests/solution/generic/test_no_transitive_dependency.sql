-- =============================================================================
-- Singular Test: No Transitive Dependency (Inmon 3NF)
-- Verifies that fact_order_3nf does not contain descriptive attributes that
-- belong to a dimension (cust_name, product_name, category, etc.).
-- In a true 3NF design, facts hold only keys and measures.
-- Any returned row identifies a column that violates this rule.
-- =============================================================================

select
    column_name,
    'fact_order_3nf contains a dimension attribute — transitive dependency violation' as reason
from information_schema.columns
where lower(table_name)   = 'fact_order_3nf'
  and lower(table_schema) like '%inmon%'
  and lower(column_name)  in (
      -- Customer dimension attributes
      'cust_name', 'cust_email', 'cust_country', 'cust_city', 'cust_segment',
      -- Product dimension attributes
      'product_name', 'category', 'subcategory', 'sku', 'price', 'cost', 'is_active'
  )

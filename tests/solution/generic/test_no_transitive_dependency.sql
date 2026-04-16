-- =============================================================================
-- Generic Test: No Transitive Dependency (Inmon 3NF)
-- Verifies that a fact table does not contain descriptive attributes that
-- belong to a dimension (cust_name, product_name, category, etc.).
-- In a true 3NF design, facts hold only keys and measures.
-- Any returned row identifies a column that violates this rule.
--
-- Usage (schema.yml):
--   models:
--     - name: fact_order_3nf
--       data_tests:
--         - no_transitive_dependency:
--             column_name: order_id
-- =============================================================================

{% test no_transitive_dependency(model, column_name) %}

select
    column_name,
    'fact table contains a dimension attribute — transitive dependency violation' as reason
from information_schema.columns
where lower(table_name)   = lower('{{ model.identifier }}')
  and lower(table_schema) = lower('{{ model.schema }}')
  and lower(column_name)  in (
      -- Customer dimension attributes
      'cust_name', 'cust_email', 'cust_country', 'cust_city', 'cust_segment',
      -- Product dimension attributes
      'product_name', 'category', 'subcategory', 'sku', 'price', 'cost', 'is_active'
  )

{% endtest %}

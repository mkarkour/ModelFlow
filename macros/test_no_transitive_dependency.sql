-- =============================================================================
-- Custom Generic Test: 3NF No Transitive Dependency
-- Architecture : Inmon 3NF
-- Purpose      : Verify that a fact table does not contain descriptive
--                attributes that belong to a referenced dimension. In a true
--                3NF design, facts hold only keys and measures — no redundant
--                dimension attributes (transitive dependency violation).
-- Usage (in schema.yml):
--   models:
--     - name: fact_order_3nf
--       tests:
--         - no_transitive_dependency:
--             fk_column: cust_id
--             dimension_model: ref('dim_customer_3nf')
--             dimension_attributes: ['cust_name', 'cust_email', 'cust_country']
-- =============================================================================

{% test no_transitive_dependency(model, fk_column, dimension_model, dimension_attributes) %}

{%- set fact_columns_query %}
    select column_name
    from information_schema.columns
    where table_name = '{{ model.name }}'
      and table_schema = '{{ model.schema }}'
{% endset -%}

{%- set results = run_query(fact_columns_query) -%}
{%- set fact_columns = results.columns[0].values() | map('lower') | list -%}

{%- set violations = [] -%}
{%- for attr in dimension_attributes -%}
    {%- if attr | lower in fact_columns -%}
        {%- do violations.append(attr) -%}
    {%- endif -%}
{%- endfor -%}

{%- if violations | length > 0 %}
select
    '{{ violations | join(", ") }}' as violating_columns,
    'Fact table contains dimension attributes: transitive dependency violation' as violation_reason
{%- else %}
select
    cast(null as varchar) as violating_columns,
    cast(null as varchar) as violation_reason
where 1 = 0
{%- endif %}

{% endtest %}

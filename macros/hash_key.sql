{% macro hash_key(columns) %}
    {#
        Generates a Data Vault-style Hash Key using MD5.
        Pass a list of column names that form the business key.
        Nulls are replaced with '^^' to avoid hash collisions.

        Usage:
            {{ generate_hash_key(['cust_id']) }}
            {{ generate_hash_key(['cust_id', 'prod_id']) }}
    #}
    lower(
        md5(
            {%- for col in columns %}
                coalesce(cast({{ col }} as varchar), '^^')
                {%- if not loop.last %} || '||' || {% endif %}
            {%- endfor %}
        )
    )
{% endmacro %}

{% macro hash_diff(columns) %}
    {#
        Generates a hash diff for Data Vault Satellites to detect row changes.
        Combines all descriptive attributes into a single MD5 fingerprint.

        Usage:
            {{ hash_diff(['name', 'email', 'country']) }}
    #}
    lower(
        md5(
            {%- for col in columns %}
                coalesce(cast({{ col }} as varchar), '^^')
                {%- if not loop.last %} || '|' || {% endif %}
            {%- endfor %}
        )
    )
{% endmacro %}

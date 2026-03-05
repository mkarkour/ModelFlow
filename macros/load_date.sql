{% macro load_date() %}
    {#
        Returns the current UTC timestamp as the Load Date for Data Vault patterns.
        In production this would typically be the pipeline execution timestamp.
    #}
    cast(current_timestamp as timestamp)
{% endmacro %}

{% macro check_mode() %}
  {% set current_mode = env_var('DBT_MODE', 'exercise') %}
  {{ log("------------------------------------------------", info=True) }}
  {{ log("🚀 CURRENT DBT MODE: " ~ current_mode | upper, info=True) }}
  {% if current_mode == 'exercise' %}
    {{ log("📝 Running models from: models/<Architecture>/exercise/", info=True) }}
  {% else %}
    {{ log("✅ Running models from: models/<Architecture>/solution/", info=True) }}
  {% endif %}
  {{ log("------------------------------------------------", info=True) }}
{% endmacro %}

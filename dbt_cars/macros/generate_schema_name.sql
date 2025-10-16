{% macro generate_schema_name(custom_schema_name, node) -%}
    {# Nếu model có khai báo +schema, dùng nó trực tiếp #}
    {% if custom_schema_name is not none %}
        {{ custom_schema_name }}
    {% else %}
        {{ target.schema }}
    {% endif %}
{%- endmacro %}
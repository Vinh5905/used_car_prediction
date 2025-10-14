{% macro select_all_except(model, exclude=[]) %}
    {%- set cols = adapter.get_columns_in_relation(ref(model)) -%}
    {%- for col in cols if col.name not in exclude -%}
        {{ col.name }}{% if not loop.last %}, {% endif %}
    {%- endfor -%}
{% endmacro %}
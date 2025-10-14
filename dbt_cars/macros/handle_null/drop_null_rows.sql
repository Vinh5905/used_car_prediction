{% macro drop_null_rows(cols) %}
    {% set conditions = [] %}
    {% for c in cols %}
        {% do conditions.append(c ~ ' IS NOT NULL') %}
    {% endfor %}
    ({{ conditions | join(' OR ') }})
{% endmacro %}
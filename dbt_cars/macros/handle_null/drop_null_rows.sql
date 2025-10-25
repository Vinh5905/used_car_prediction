{% macro drop_null_rows(cols) %}
    {% set conditions = [] %}
    {% for c in cols %}
        {% do conditions.append(c ~ ' IS NOT NULL') %}
        {% do conditions.append(c ~ " != ''") %}
    {% endfor %}
    ({{ conditions | join(' AND ') }})
{% endmacro %}
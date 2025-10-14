{% macro normalize_color(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        WHEN {{ col }} IN ('màu khác', '-', 'khác', 'khac') THEN 'Khác'
        ELSE INITCAP({{ col }})
    END
{% endmacro %}
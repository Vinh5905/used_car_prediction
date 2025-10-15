{% macro normalize_date(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        WHEN LOWER(TRIM({{ col }})) IN ('null', 'none', 'nan', 'n/a', '?', '-') THEN NULL
        ELSE TO_DATE({{ col }}, 'DD/MM/YYYY')
    END
{% endmacro %}
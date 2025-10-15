{% macro normalize_date(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        WHEN LOWER(TRIM({{ col }})) IN ('null', 'none', 'nan', 'n/a', '?', '-') THEN NULL
        ELSE COALESCE(
            TO_DATE(date_posted, 'YYYY-MM-DD'),
            TO_DATE(date_posted, 'DD/MM/YYYY'),
            TO_DATE(date_posted, 'MM/DD/YYYY'),
            TO_DATE(date_posted, 'YYYY.MM.DD')
        )
    END
{% endmacro %}
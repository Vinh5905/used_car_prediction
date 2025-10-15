{% macro normalize_text(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        WHEN LOWER(TRIM({{ col }})) IN ('null', 'none', 'nan', 'n/a') THEN NULL
        ELSE LOWER(
            TRIM(
                regexp_replace({{ col }}, '[\t\n\r]+', ' ')
            )
        )
    END
{% endmacro %}
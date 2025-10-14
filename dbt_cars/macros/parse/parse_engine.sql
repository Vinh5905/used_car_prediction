{% macro parse_engine_type(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        ELSE INITCAP(
            REGEXP_SUBSTR({{ col }}, '^[A-Za-zÀ-ỹ]+')
        )
    END
{% endmacro %}
{% macro parse_mileage(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        ELSE
            CAST(
                CASE
                    WHEN REGEXP_REPLACE(REGEXP_SUBSTR({{ col }}, '([\d.,]+)'), ',', '') ~ '^[0-9]+$'
                    THEN
                        CAST(REGEXP_REPLACE(REGEXP_SUBSTR({{ col }}, '([\d.,]+)'), ',', '') AS NUMERIC)
                    ELSE NULL
                END
            AS BIGINT)
    END
{% endmacro %}
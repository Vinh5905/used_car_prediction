{% macro parse_mileage(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        ELSE
            CAST(
                NULLIF(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE({{ col }}, '(?i)km', ''),  -- bỏ chữ 'km', case insensitive
                        '[.,]', ''                                  -- bỏ dấu ',' hoặc '.'
                    ),
                    ''
                ) AS BIGINT
            )
    END
{% endmacro %}
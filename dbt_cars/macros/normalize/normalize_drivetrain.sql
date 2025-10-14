{% macro normalize_drivetrain(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL

        -- Lấy mã drivetran đầu tiên, viết hoa
        ELSE UPPER(
            REGEXP_SUBSTR({{ col }}, '([A-Za-z0-9]+)')
        )
    END
{% endmacro %}
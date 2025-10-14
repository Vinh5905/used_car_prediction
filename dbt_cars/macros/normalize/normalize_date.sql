{% macro normalize_date(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        WHEN LOWER(TRIM({{ col }})) IN ('null', 'none', 'nan', 'n/a', '?', '-') THEN NULL
        ELSE TRY_CAST(
            COALESCE( -- Lấy giá trị không NULL đầu tiên
                TRY_CAST({{ col }} AS DATE),
                TRY_CAST(TO_DATE({{ col }}, 'DD/MM/YYYY')),
                TRY_CAST(TO_DATE({{ col }}, 'MM/DD/YYYY')),
                TRY_CAST(TO_DATE({{ col }}, 'YYYY-MM-DD')),
                TRY_CAST(TO_DATE({{ col }}, 'YYYY.MM.DD'))
                -- ✅ Snowflake: DATE
                -- ⚠️ PostgreSQL: có thể TIMESTAMP nếu không đúng context
            ) AS DATE -- Đảm bảo kết quả là DATE
        )
    END
{% endmacro %}
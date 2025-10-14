{% macro parse_vnd_amount(col) %}
    CASE
        WHEN {{ col }} IS NULL THEN NULL
        ELSE
            CAST(
                CASE
                    -- Tách số và đơn vị
                    WHEN REGEXP_SUBSTR({{ col }}, '([\d.,]+)\s*(.*)') IS NULL THEN NULL
                    ELSE
                        -- Lấy phần số
                        (
                            CASE
                                WHEN REGEXP_REPLACE(REGEXP_SUBSTR({{ col }}, '([\d.,]+)'), ',', '.') ~ '^[0-9.]+$'
                                THEN
                                    CAST(REGEXP_REPLACE(REGEXP_SUBSTR({{ col }}, '([\d.,]+)'), ',', '.') AS NUMERIC)
                                ELSE NULL
                            END
                        ) *
                        -- Xử lý đơn vị
                        CASE
                            WHEN {{ col }} LIKE '%tỷ%' OR {{ col }} LIKE '%ty%' THEN 1000000000
                            WHEN {{ col }} LIKE '%triệu%' OR {{ col }} LIKE '%trieu%' THEN 1000000
                            WHEN {{ col }} LIKE '%nghìn%' OR {{ col }} LIKE '%ngàn%' THEN 1000
                            ELSE 1
                        END
                END
            AS BIGINT)
    END
{% endmacro %}
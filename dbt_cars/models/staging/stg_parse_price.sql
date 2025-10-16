{{ config(
    description='Parse giá tiền sang số VND từ bảng normalize_final'
) }}

SELECT
    {{ select_all_except('stg_final_normalize', ['price']) }},
    {{ parse_vnd_amount('price') }} AS price
FROM {{ ref('stg_final_normalize') }}
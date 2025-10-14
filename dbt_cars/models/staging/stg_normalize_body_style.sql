{{ config(
    materialized='table',
    alias='cars_normalize_body_style',
    description='Bước chuẩn hóa body style'
) }}

SELECT
    {{ select_all_except('stg_normalize_base', ['body_style']) }},
    {{ normalize_body_style('body_style') }} AS body_style
FROM {{ ref('stg_normalize_base') }}
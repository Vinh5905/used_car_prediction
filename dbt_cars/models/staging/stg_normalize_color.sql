{{ config(
    materialized='table',
    alias='cars_normalize_color',
    description='Bước chuẩn hóa màu nội thất và ngoại thất'
) }}

SELECT
    {{ select_all_except('stg_normalize_body_style', ['exterior_color', 'interior_color']) }},
    {{ normalize_color('exterior_color') }} AS exterior_color,
    {{ normalize_color('interior_color') }} AS interior_color
FROM {{ ref('stg_normalize_body_style') }}
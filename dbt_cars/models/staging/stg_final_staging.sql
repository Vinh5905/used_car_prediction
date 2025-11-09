{{ config(
    description='Bảng staging cuối cùng, dữ liệu sạch cho marts'
) }}

SELECT *
FROM {{ ref('stg_final_enrich') }}
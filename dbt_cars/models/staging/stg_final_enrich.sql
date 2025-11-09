{{ config(
    description='Bảng enrich cuối cùng toàn bảng cars'
) }}

SELECT *
FROM {{ ref('stg_enrich_mileage') }}
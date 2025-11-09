{{ config(
    description='Tạo cột phân loại mileage cho xe.'
) }}

WITH source AS (
    SELECT * FROM {{ ref('stg_final_handle_null') }}
)

SELECT 
    *,
    CASE 
        WHEN mileage <= 10000 THEN '0-10.000 km'
        WHEN mileage <= 20000 THEN '10.001-20.000 km'
        WHEN mileage <= 50000 THEN '20.001-50.000 km'
        WHEN mileage <= 100000 THEN '50.001-100.000 km'
        ELSE '> 100.000 km'
    END as mileage_category
FROM source

{{ config(
    materialized='table',
    description='Dimension table chứa thông tin chi tiết về xe như năm sản xuất và xuất xứ'
) }}

WITH source AS (
    SELECT DISTINCT
        year,
        origin,
        mileage_category
    FROM {{ ref('stg_final_staging') }}
),

final AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY year, origin, mileage_category) as car_details_id,
        year,
        origin,
        mileage_category
    FROM source
)

SELECT * FROM final

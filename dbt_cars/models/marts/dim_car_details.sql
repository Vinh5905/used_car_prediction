{{ config(
    materialized='table',
    description='Dimension table chứa thông tin chi tiết về xe như năm sản xuất và xuất xứ'
) }}

WITH source AS (
    SELECT DISTINCT
        year,
        origin
    FROM {{ ref('stg_final_staging') }}
),

final AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY year, origin) as car_details_id,
        year,
        origin
    FROM source
)

SELECT * FROM final

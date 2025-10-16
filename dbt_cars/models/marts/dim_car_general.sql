{{ config(
    materialized='table',
    description='Dimension table chứa thông tin chung về xe như brand, model, body style'
) }}

WITH source AS (
    SELECT DISTINCT
        brand,
        model,
        body_style
    FROM {{ ref('stg_final_staging') }}
),

final AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY brand, model) as car_general_id,
        brand,
        model,
        body_style
    FROM source
)

SELECT * FROM final

{{ config(
    materialized='table',
    description='Dimension table chứa thông số kỹ thuật của xe như hộp số, động cơ, hệ thống truyền động và màu sắc'
) }}

WITH source AS (
    SELECT DISTINCT
        transmission,
        engine,
        drivetrain,
        exterior_color,
        interior_color
    FROM {{ ref('stg_final_staging') }}
),

final AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY transmission, engine, drivetrain) as car_specs_id,
        transmission,
        engine,
        drivetrain,
        exterior_color,
        interior_color
    FROM source
)

SELECT * FROM final

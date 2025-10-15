{{ config(
    materialized='table',
    description='Loại bỏ xe mới và các cột không cần thiết từ raw.cars.'
) }}

WITH filtered AS (
    SELECT
        *
    FROM {{ source('raw', 'raw_cars') }}
    WHERE car_condition != 'Xe mới'
)

SELECT
    id,
    brand,
    model,
    year,
    price,
    mileage,
    origin,
    body_style,
    transmission,
    engine,
    exterior_color,
    interior_color,
    drivetrain,
    date_posted
FROM filtered
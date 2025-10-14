{{ config(
    materialized='table',
    alias='cars_filter_data_cols',
    tags=['Data Warehouse', 'Staging'],
    description='Bước 1: Loại bỏ xe mới và các cột không cần thiết từ raw.cars_ingestion.'
) }}

WITH filtered AS (
    SELECT
        *
    FROM {{ source('raw', 'cars_ingestion') }}
    WHERE car_condition != 'Xe mới'
)

SELECT
    id,
    brand,
    model,
    year,
    price,
    mileage,
    transmission,
    fuel_type,
    body_style,
    engine,
    exterior_color,
    interior_color,
    drivetrain,
    date_posted
FROM filtered
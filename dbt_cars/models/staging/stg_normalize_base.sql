{{ config(
    materialized='table',
    alias='cars_normalize_base',
    description='Bước chuẩn hóa sơ bộ toàn bảng raw.cars_ingestion.'
) }}

SELECT
    id,
    year,

    {{ normalize_text('brand') }} AS brand,
    {{ normalize_text('model') }} AS model,
    {{ normalize_text('price') }} AS price,
    {{ normalize_text('mileage') }}  AS mileage,
    {{ normalize_text('transmission') }} AS transmission,
    {{ normalize_text('fuel_type') }} AS fuel_type,
    {{ normalize_text('body_style') }} AS body_style,
    {{ normalize_text('engine') }} AS engine,
    {{ normalize_text('exterior_color') }} AS exterior_color,
    {{ normalize_text('interior_color') }} AS interior_color,
    {{ normalize_text('drivetrain') }} AS drivetrain,

    {{ normalize_date('date_posted') }} AS date_posted
FROM {{ ref('stg_filter_data_cols') }}

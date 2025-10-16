{{ config(
    materialized='table',
    description='Fact table kết nối các bảng dimension và chứa các metrics như giá và số km đã đi'
) }}

WITH staging AS (
    SELECT 
        *
    FROM {{ ref('stg_final_staging') }}
),

final AS (
    SELECT
        s.id,
        s.price,
        s.mileage,
        cg.car_general_id,
        cd.car_details_id,
        cs.car_specs_id,
        s.date_posted as date_id
    FROM staging s
    LEFT JOIN {{ ref('dim_car_general') }} cg
        ON s.brand = cg.brand 
        AND s.model = cg.model 
        AND s.body_style = cg.body_style
    LEFT JOIN {{ ref('dim_car_details') }} cd
        ON s.year = cd.year 
        AND s.origin = cd.origin
    LEFT JOIN {{ ref('dim_car_specs') }} cs
        ON s.transmission = cs.transmission 
        AND s.engine = cs.engine 
        AND s.drivetrain = cs.drivetrain 
        AND s.exterior_color = cs.exterior_color
        AND s.interior_color = cs.interior_color
)

SELECT * FROM final

-- Bảng mapping ý nghĩa (phục vụ cho việc hiểu value) 
-- drivetrain_mapping = { 
--     'FWD': 'Dẫn động cầu trước', 
--     'RWD': 'Dẫn động cầu sau', 
--     'AWD': '4 bánh toàn thời gian', 
--     '4WD': 'Dẫn động 4 bánh' 
-- }

{{ config(
    materialized='table',
    description='Bước chuẩn hóa cột drivetrain'
) }}

SELECT
    {{ select_all_except('stg_normalize_color', ['drivetrain']) }},
    {{ normalize_drivetrain('drivetrain') }} AS drivetrain
FROM {{ ref('stg_normalize_color') }}
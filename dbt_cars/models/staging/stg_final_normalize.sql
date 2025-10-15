{{ config(
    materialized='table',
    description='Bảng chuẩn hóa cuối cùng toàn bảng cars'
) }}

SELECT *
FROM {{ ref('stg_normalize_drivetrain') }}
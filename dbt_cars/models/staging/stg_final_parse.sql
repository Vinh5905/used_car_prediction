{{ config(
    materialized='table',
    description='Bảng parse cuối cùng toàn bảng cars'
) }}

SELECT *
FROM {{ ref('stg_parse_date_posted') }}
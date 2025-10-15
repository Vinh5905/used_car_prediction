{{ config(
    materialized='table',
    description='Tách date_posted thành day, month, year nhưng vẫn giữ date_posted.'
) }}

SELECT
    *,
    EXTRACT(DAY FROM date_posted) AS day_value,
    EXTRACT(MONTH FROM date_posted) AS month_value,
    EXTRACT(YEAR FROM date_posted) AS year_value
FROM {{ ref('stg_parse_engine') }}
{{ config(
    materialized='table',
    description='Dimension table cho thời gian, sử dụng các giá trị ngày tháng năm có sẵn'
) }}

WITH source AS (
    SELECT DISTINCT
        date_posted,
        day_value,
        month_value,
        year_value
    FROM {{ ref('stg_final_staging') }}
),

final AS (
    SELECT
        date_posted as date_id,
        day_value,
        month_value,
        year_value
    FROM source
)

SELECT * FROM final

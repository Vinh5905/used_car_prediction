{{ config(
    materialized='table',
    description='Parse mileage sang số km'
) }}

WITH parsed_mileage AS (
    SELECT
        {{ select_all_except('stg_parse_price', ['mileage']) }},
        {{ parse_mileage('mileage') }} AS mileage
    FROM {{ ref('stg_parse_price') }}
)

SELECT *
FROM parsed_mileage
WHERE mileage IS NOT NULL 
  AND mileage != 0
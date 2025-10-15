{{ config(
    materialized='table',
    description='Parse mileage sang số km'
) }}

SELECT
    {{ select_all_except('stg_parse_price', ['mileage']) }},
    {{ parse_mileage('mileage') }} AS mileage
FROM {{ ref('stg_parse_price') }}
WHERE mileage != 0
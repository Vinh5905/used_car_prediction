{{ config(
    materialized='table',
    alias='cars_parse_engine',
    description='Parse loại động cơ (engine)'
) }}

SELECT
    {{ select_all_except('stg_parse_mileage', ['engine']) }},
    {{ parse_engine_type('engine') }} AS engine
FROM {{ ref('stg_parse_mileage') }}
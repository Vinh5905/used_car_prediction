{{ config(
    materialized='table',
    description='Parse loại động cơ (engine)'
) }}

SELECT
    {{ select_all_except('stg_parse_mileage', ['engine']) }},
    {{ parse_engine_type('engine') }} AS engine
FROM {{ ref('stg_parse_mileage') }}
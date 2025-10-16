{{ config(
    description='Bảng xử lý null cuối cùng toàn bảng cars'
) }}

SELECT * 
FROM {{ ref('stg_handle_null_brand_model') }}
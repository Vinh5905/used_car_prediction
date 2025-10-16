{{ config(
    description='Parse dữ liệu cars và loại bỏ các dòng brand + model NULL'
) }}

SELECT *
FROM {{ ref('stg_final_parse') }}
WHERE {{ drop_null_rows(['brand', 'model']) }}
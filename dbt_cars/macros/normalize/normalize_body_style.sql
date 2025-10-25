{% macro normalize_body_style(col) %}
    CASE
        WHEN {{ col }} IS NULL OR TRIM({{ col }}) = '' THEN NULL
        WHEN {{ col }} LIKE '%suv%' THEN 'SUV'
        WHEN {{ col }} LIKE '%sedan%' THEN 'Sedan'
        WHEN {{ col }} LIKE '%crossover%' THEN 'Crossover'
        WHEN {{ col }} LIKE '%hatchback%' THEN 'Hatchback'
        WHEN {{ col }} LIKE '%pickup%' THEN 'Pickup'
        WHEN {{ col }} LIKE '%van%' OR {{ col }} LIKE '%minivan%' THEN 'Minivan'
        WHEN {{ col }} LIKE '%coupe%' THEN 'Coupe'
        WHEN {{ col }} LIKE '%convertible%' OR {{ col }} LIKE '%cabriolet%' THEN 'Cabriolet'
        WHEN {{ col }} LIKE '%truck%' THEN 'Truck'
        WHEN {{ col }} LIKE '%wagon%' THEN 'Wagon'

        ELSE INITCAP({{ col }}) -- Viết hoa chữ cái đầu (giống style.capitalize())
    END
{% endmacro %}
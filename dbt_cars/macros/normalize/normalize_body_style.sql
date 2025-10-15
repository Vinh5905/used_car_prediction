{% macro normalize_body_style(col) %}
    CASE
        WHEN {{ col }} IS NULL OR TRIM({{ col }}) = '' THEN NULL
        WHEN {{ col }} IN ('suv') THEN 'SUV'
        WHEN {{ col }} IN ('sedan') THEN 'Sedan'
        WHEN {{ col }} IN ('crossover') THEN 'Crossover'
        WHEN {{ col }} IN ('hatchback') THEN 'Hatchback'
        WHEN {{ col }} IN ('bán tải / pickup', 'ban tai / pickup', 'pickup') THEN 'Pickup'
        WHEN {{ col }} IN ('van', 'minivan', 'van/minivan') THEN 'Minivan'
        WHEN {{ col }} IN ('coupe') THEN 'Coupe'
        WHEN {{ col }} IN ('convertible', 'cabriolet', 'convertible/cabriolet') THEN 'Cabriolet'
        WHEN {{ col }} IN ('truck') THEN 'Truck'
        WHEN {{ col }} IN ('wagon') THEN 'Wagon'

        ELSE INITCAP({{ col }}) -- Viết hoa chữ cái đầu (giống style.capitalize())
    END
{% endmacro %}
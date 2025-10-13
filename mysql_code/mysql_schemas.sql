DROP TABLE IF EXISTS cars;

CREATE TABLE cars (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price VARCHAR(50),
    brand VARCHAR(100),
    model VARCHAR(100),
    date_posted VARCHAR(20),
    year INT,
    car_condition VARCHAR(50),
    mileage VARCHAR(50),
    origin VARCHAR(100),
    body_style VARCHAR(50),
    transmission VARCHAR(50),
    engine VARCHAR(100),
    exterior_color VARCHAR(50),
    interior_color VARCHAR(50),
    seats VARCHAR(20),
    doors VARCHAR(20),
    drivetrain VARCHAR(100),
    seller_name VARCHAR(255),
    seller_phone VARCHAR(20),
    seller_address TEXT
);

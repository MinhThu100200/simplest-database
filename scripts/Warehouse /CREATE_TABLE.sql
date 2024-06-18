CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_TIMESTAMP,
    customer_id INT,
    employee_id INT,
    total_amount DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    delivery_address_id INT,
    delivery_address VARCHAR(500),
    delivery_method VARCHAR(100),
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE order_detail (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    product_name VARCHAR(200),
    product_image VARCHAR(500),
    quantity INT,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price_sale DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    status BOOLEAN
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    username VARCHAR(50),
    password VARCHAR(50),
    position VARCHAR(50),
    phone VARCHAR(20),
    access_privileges VARCHAR(100),
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    status BOOLEAN
);
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS fact_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_date DATE DEFAULT CURRENT_TIMESTAMP,
    customer_id UUID,
    employee_id UUID,
    total_amount DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    delivery_address_id VARCHAR(50),
    delivery_address VARCHAR(500),
    delivery_method VARCHAR(100),
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_order_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID,
    product_id UUID,
    product_name text,
    product_image VARCHAR(300),
    quantity INT,
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price_sale DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS dim_customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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

CREATE TABLE IF NOT EXISTS dim_employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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

CREATE TABLE IF NOT EXISTS dim_categories(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(500),
    information text,
    images VARCHAR(300),
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    status BOOLEAN
);

CREATE TABLE IF NOT EXISTS fact_products(
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(500),
    description text,
    information text,
    images text [],
    stock INT,
    price NUMERIC(10, 2),
    created_by VARCHAR(50),
    updated_by VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    status BOOLEAN,
    category_id UUID
);

-- CATEGORY TABLE CONSTRAINT
ALTER TABLE
    dim_categories
ALTER COLUMN
    name
SET
    NOT NULL,
ALTER COLUMN
    information
SET
    NOT NULL,
ALTER COLUMN
    images
SET
    NOT NULL,
ALTER COLUMN
    created_by
SET
    NOT NULL,
ALTER COLUMN
    updated_by
SET
    NOT NULL,
ALTER COLUMN
    created_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    updated_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    status
SET
    DEFAULT true;

-- PRODUCTS TABLE CONSTRAINT
ALTER TABLE
    fact_products
ALTER COLUMN
    name
SET
    NOT NULL,
ALTER COLUMN
    information
SET
    NOT NULL,
ALTER COLUMN
    description
SET
    NOT NULL,
ALTER COLUMN
    images
SET
    NOT NULL,
ALTER COLUMN
    stock
SET
    NOT NULL,
ALTER COLUMN
    price
SET
    NOT NULL,
ALTER COLUMN
    created_by
SET
    NOT NULL,
ALTER COLUMN
    updated_by
SET
    NOT NULL,
ALTER COLUMN
    created_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    updated_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    status
SET
    DEFAULT true,
ADD
    CONSTRAINT check_stock CHECK (stock >= 0),
ADD
    CONSTRAINT check_price CHECK (price >= 0),
ADD
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES dim_categories(id);

-- ORDERS TABLE CONSTRAINT
ALTER TABLE
    fact_orders
ALTER COLUMN
    customer_id
SET
    NOT NULL,
ALTER COLUMN
    employee_id
SET
    NOT NULL,
ALTER COLUMN
    total_amount
SET
    NOT NULL,
ALTER COLUMN
    discount_amount
SET
    NOT NULL,
ALTER COLUMN
    delivery_method
SET
    NOT NULL,
ALTER COLUMN
    delivery_address
SET
    NOT NULL,
ALTER COLUMN
    delivery_address_id
SET
    NOT NULL,
ALTER COLUMN
    created_by
SET
    NOT NULL,
ALTER COLUMN
    updated_by
SET
    NOT NULL,
ALTER COLUMN
    order_date
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    created_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    updated_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ADD
    CONSTRAINT fk_order_employee FOREIGN KEY (employee_id) REFERENCES dim_employees (id),
ADD
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES dim_customers (id);

-- ORDER_DETAIL TABLE CONSTRAINT
ALTER TABLE
    dim_order_details
ALTER COLUMN
    order_id
SET
    NOT NULL,
ALTER COLUMN
    product_id
SET
    NOT NULL,
ALTER COLUMN
    product_name
SET
    NOT NULL,
ALTER COLUMN
    product_image
SET
    NOT NULL,
ALTER COLUMN
    quantity
SET
    NOT NULL,
ALTER COLUMN
    price_sale
SET
    NOT NULL,
ALTER COLUMN
    discount_amount
SET
    NOT NULL,
ALTER COLUMN
    created_by
SET
    NOT NULL,
ALTER COLUMN
    updated_by
SET
    NOT NULL,
ALTER COLUMN
    unit
SET
    NOT NULL,
ALTER COLUMN
    created_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    updated_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ADD
    CONSTRAINT check_quantity CHECK(quantity > 0),
ADD
    CONSTRAINT fk_order_detail_order FOREIGN KEY (order_id) REFERENCES fact_orders (id);

-- CUSTOMERS TABLE CONSTRAINT
ALTER TABLE
    dim_customers
ALTER COLUMN
    first_name
SET
    NOT NULL,
ALTER COLUMN
    last_name
SET
    NOT NULL,
ALTER COLUMN
    phone
SET
    NOT NULL,
ALTER COLUMN
    created_by
SET
    NOT NULL,
ALTER COLUMN
    updated_by
SET
    NOT NULL,
ALTER COLUMN
    created_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    updated_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    status
SET
    DEFAULT true,
ADD
    CONSTRAINT customer_phone_unq UNIQUE(phone);

-- EMPLOYEES TABLE CONSTRAINT
ALTER TABLE
    dim_employees
ALTER COLUMN
    first_name
SET
    NOT NULL,
ALTER COLUMN
    last_name
SET
    NOT NULL,
ALTER COLUMN
    phone
SET
    NOT NULL,
ALTER COLUMN
    created_by
SET
    NOT NULL,
ALTER COLUMN
    updated_by
SET
    NOT NULL,
ALTER COLUMN
    access_privileges
SET
    NOT NULL,
ALTER COLUMN
    username
SET
    NOT NULL,
ALTER COLUMN
    password
SET
    NOT NULL,
ALTER COLUMN
    created_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    updated_at
SET
    DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN
    status
SET
    DEFAULT true,
ADD
    CONSTRAINT employee_phone_unq UNIQUE(phone);
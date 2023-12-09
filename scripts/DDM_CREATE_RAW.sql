CREATE TABLE customer (
    id SERIAL PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN DEFAULT true
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT true,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    status BOOLEAN DEFAULT true,
    category_id INT NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE employee (
    id SERIAL PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    access_privileges VARCHAR(100) NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN DEFAULT true
);

CREATE TABLE price_history (
    product_id SERIAL NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    effective_date DATE DEFAULT CURRENT_TIMESTAMP,
    change_reason TEXT,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, effective_date, price),
    CONSTRAINT fk_price_history_product FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE delivery_address (
    id SERIAL PRIMARY KEY NOT NULL,
    customer_id INT NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_delivery_address_customer FOREIGN KEY (customer_id) REFERENCES customer(id)
);

CREATE TABLE vat_history (
    category_id INT NOT NULL,
    vat REAL NOT NULL,
    effective_date DATE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id, effective_date, vat),
    CONSTRAINT fk_vat_history_category FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE type_discount (
    id SERIAL PRIMARY KEY NOT NULL,
    value_type VARCHAR(50) NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE strategy (
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    effective_date DATE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50) NOT NULL,
    expired_date TIMESTAMP NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE camping (
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    camping_value REAL DEFAULT 0,
    expired_date TIMESTAMP NOT NULL,
    camping_condition_bill DECIMAL(10, 2) DEFAULT 0,
    amount INT NOT NULL,
    strategy_id INT NOT NULL,
    type_discount_id INT NOT NULL,
    effective_date DATE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_camping_type_discount FOREIGN KEY (type_discount_id) REFERENCES type_discount(id)
);

CREATE TABLE strategy_camping (
    strategy_id INT REFERENCES strategy(id) NOT NULL,
    camping_id INT REFERENCES camping(id) NOT NULL,
    PRIMARY KEY (strategy_id, camping_id)
);

CREATE TABLE product_camping (
    product_id INT REFERENCES product(id) NOT NULL,
    camping_id INT REFERENCES camping(id) NOT NULL,
    PRIMARY KEY (product_id, camping_id)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY NOT NULL,
    order_date DATE DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    camping_id INT DEFAULT -1,
    delivery_address_id INT NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) REFERENCES employee(id),
    CONSTRAINT fk_orders_delivery_address FOREIGN KEY (delivery_address_id) REFERENCES delivery_address(id)
);

CREATE TABLE order_camping (
    camping_id INT REFERENCES camping(id) NOT NULL,
    order_id INT REFERENCES orders(id) NOT NULL,
    PRIMARY KEY (order_id, camping_id)
);

CREATE TABLE order_details (
    id SERIAL PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price_product_order DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_details_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_order_details_product FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE payment (
    id SERIAL PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) DEFAULT 'Cash',
    created_by VARCHAR(50) NOT NULL,
    updated_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer(id)
);
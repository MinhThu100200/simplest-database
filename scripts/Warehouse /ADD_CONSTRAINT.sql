-- ORDERS TABLE CONSTRAINT
ALTER TABLE
    orders
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
    CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) REFERENCES employees (id),
ADD
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers (id);

-- ORDER_DETAIL TABLE CONSTRAINT
ALTER TABLE
    order_detail
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
    CONSTRAINT fk_order_detail_orders FOREIGN KEY (order_id) REFERENCES orders (id);

-- CUSTOMERS TABLE CONSTRAINT
ALTER TABLE
    customers
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
    employees
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
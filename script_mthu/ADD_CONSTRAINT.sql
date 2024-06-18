-- check CONSTRAINT 
ALTER TABLE
    product DROP CONSTRAINT IF EXISTS product_unq;

-- UNIQUE
ALTER TABLE
    product
ADD
    CONSTRAINT product_unq UNIQUE(id);

-- NOT NULL
ALTER TABLE
    product
ALTER COLUMN
    name
SET
    NOT NULL;

-- DEFAULT
ALTER TABLE
    product
ALTER COLUMN
    name
SET
    DEFAULT 1;

-- REMOVE NOT NULL
ALTER TABLE
    product
ALTER COLUMN
    name DROP NOT NULL;

-- FOREIGN KEY
ALTER TABLE
    product
ADD
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category (id);

-- PRIMARY KEY
ALTER TABLE
    product
ADD
    PRIMARY KEY (id);

ALTER TABLE
    product
ADD
    COLUMN id SERIAL PRIMARY KEY;

-- REMOVE CONSTRAINT
ALTER TABLE
    product DROP CONSTRAINT product_pkey;
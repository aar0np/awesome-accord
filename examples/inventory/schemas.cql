-- Inventory management system schema

CREATE KEYSPACE IF NOT EXISTS inventory WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

-- Product catalog and inventory
CREATE TABLE inventory.products (
    product_id text,
    name text,
    description text,
    category text,
    price decimal,
    stock_count decimal,
    reserved_count decimal,
    min_stock_level decimal,
    last_restock_date timestamp,
    status text,
    PRIMARY KEY (product_id)
) WITH transactional_mode = 'full';

-- Products by category for browsing
CREATE TABLE inventory.products_by_category (
    category text,
    product_id text,
    name text,
    price decimal,
    stock_count decimal,
    PRIMARY KEY (category, product_id)
) WITH transactional_mode = 'full';

-- Shopping cart
CREATE TABLE inventory.shopping_cart (
    cart_id text,
    user_id text,
    product_id text,
    quantity decimal,
    price_at_add decimal,
    added_date timestamp,
    expires_at timestamp,
    status text,
    PRIMARY KEY ((cart_id), product_id)
) WITH transactional_mode = 'full';

-- Shopping cart by user
CREATE TABLE inventory.cart_by_user (
    user_id text,
    cart_id text,
    created_at timestamp,
    last_updated timestamp,
    status text,
    PRIMARY KEY (user_id, cart_id)
) WITH transactional_mode = 'full';

-- Inventory transactions
CREATE TABLE inventory.inventory_transactions (
    transaction_id uuid,
    product_id text,
    transaction_type text,    -- STOCK_IN, STOCK_OUT, RESERVE, RELEASE
    quantity decimal,
    reference_id text,        -- Order ID or cart ID
    timestamp timestamp,
    status text,
    PRIMARY KEY ((product_id), timestamp, transaction_id)
) WITH transactional_mode = 'full'
    AND CLUSTERING ORDER BY (timestamp DESC, transaction_id ASC);

-- Reserved inventory
CREATE TABLE inventory.reservations (
    reservation_id text,
    product_id text,
    cart_id text,
    quantity decimal,
    reserved_at timestamp,
    expires_at timestamp,
    status text,             -- ACTIVE, COMPLETED, EXPIRED
    PRIMARY KEY (product_id, reservation_id)
) WITH transactional_mode = 'full';
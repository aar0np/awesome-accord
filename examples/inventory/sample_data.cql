-- Sample data for inventory management examples

-- Insert products
INSERT INTO inventory.products(
    product_id, name, category, 
    stock_count, reserved_count, 
    min_stock_level, last_restock_date
) VALUES (
    'PROD001', 'Gaming Console', 'Electronics',
    100, 0, 20, toTimestamp(now())
);

INSERT INTO inventory.products(
    product_id, name, category, 
    stock_count, reserved_count, 
    min_stock_level, last_restock_date
) VALUES (
    'PROD002', 'Wireless Controller', 'Electronics',
    200, 0, 30, toTimestamp(now())
);

INSERT INTO inventory.products(
    product_id, name, category, 
    stock_count, reserved_count, 
    min_stock_level, last_restock_date
) VALUES (
    'PROD003', 'Premium Headset', 'Electronics',
    50, 0, 10, toTimestamp(now())
);

-- Insert sample cart data
INSERT INTO inventory.shopping_cart(
    cart_id, user_id, product_id,
    quantity, added_date, expires_at
) VALUES (
    'CART001', 'USER001', 'PROD002',
    2, toTimestamp(now()), toTimestamp(now() + 3600)
);

-- Insert sample reservations
INSERT INTO inventory.reservations(
    reservation_id, product_id, quantity,
    status, created_at, expires_at
) VALUES (
    'RES001', 'PROD001', 1,
    'ACTIVE', toTimestamp(now()), toTimestamp(now() + 900)
);
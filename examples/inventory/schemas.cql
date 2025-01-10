-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS inventory
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Products table with transactional support
CREATE TABLE IF NOT EXISTS inventory.products (     
    item text,
    inventory_count decimal,
    PRIMARY KEY (item) 
) WITH transactional_mode = 'full'; 

-- Shopping cart table with transactional support
CREATE TABLE IF NOT EXISTS inventory.shopping_cart (
    user_name text,
    item text,
    item_count decimal,
    PRIMARY KEY (user_name, item)
) WITH transactional_mode = 'full';
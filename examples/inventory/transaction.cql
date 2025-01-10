BEGIN TRANSACTION    
    -- Find out how many PlayStations are left     
    LET inventory = (SELECT inventory_count FROM inventory.products WHERE item='PlayStation 5');     

    -- Return the inventory count before deducting     
    SELECT item, inventory_count FROM inventory.products WHERE item='PlayStation 5';

    -- Take a PlayStation out of inventory and put in users shopping cart
    IF inventory.inventory_count > 0 THEN
        UPDATE inventory.products SET inventory_count -= 1 WHERE item='PlayStation 5';
        INSERT INTO inventory.shopping_cart(user_name, item, item_count) 
        VALUES ('patrick', 'PlayStation 5', 1);
    END IF
COMMIT TRANSACTION;

-- Verify the results
SELECT * FROM inventory.products WHERE item='PlayStation 5';
SELECT * FROM inventory.shopping_cart WHERE user_name='patrick';
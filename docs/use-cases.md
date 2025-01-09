# Common Use Cases for Accord Transactions

This guide explores real-world use cases for Accord transactions in Cassandra, with complete examples and best practices.

## Financial Transactions

### Bank Transfer Example
Atomically move money between accounts while preventing overdrafts.

```sql
CREATE TABLE accounts (
    account_holder text,
    account_balance decimal,
    PRIMARY KEY (account_holder)
) WITH transactional_mode = 'full';

BEGIN TRANSACTION
    LET fromBalance = (SELECT account_balance 
                      FROM accounts 
                      WHERE account_holder='alice');

    IF fromBalance.account_balance >= 20 THEN
        UPDATE accounts SET account_balance -= 20 
        WHERE account_holder='alice';
        
        UPDATE accounts SET account_balance += 20 
        WHERE account_holder='bob';
    END IF
COMMIT TRANSACTION;
```

**Key Benefits:**
- Atomic updates across accounts
- Prevent overdrafts with balance checks
- Consistent view of balances

## Inventory Management

### Product Inventory Example
Manage product inventory with safe concurrent updates.

```sql
CREATE TABLE products (
    item text,
    inventory_count decimal,
    PRIMARY KEY (item)
) WITH transactional_mode = 'full';

CREATE TABLE shopping_cart (
    user_name text,
    item text,
    item_count decimal,
    PRIMARY KEY (user_name, item)
) WITH transactional_mode = 'full';

BEGIN TRANSACTION
    LET inventory = (SELECT inventory_count 
                    FROM products 
                    WHERE item='PlayStation 5');

    IF inventory.inventory_count > 0 THEN
        UPDATE products SET inventory_count -= 1 
        WHERE item='PlayStation 5';
        
        INSERT INTO shopping_cart(user_name, item, item_count) 
        VALUES ('user123', 'PlayStation 5', 1);
    END IF
COMMIT TRANSACTION;
```

**Key Benefits:**
- Prevent overselling
- Atomic cart updates
- Safe concurrent access

## User Management

### User Registration Example
Maintain unique user records across multiple tables.

```sql
CREATE TABLE user (
    user_id UUID,
    email text,
    country text,
    city text,
    PRIMARY KEY (user_id)
) WITH transactional_mode = 'full';

CREATE TABLE user_by_email (
    email text,
    user_id UUID,
    PRIMARY KEY (email)
) WITH transactional_mode = 'full';

BEGIN TRANSACTION
    LET existCheck = (SELECT user_id 
                     FROM user_by_email 
                     WHERE email='new@example.com');

    IF existCheck IS NULL THEN
        INSERT INTO user(user_id, email, country, city)
        VALUES (uuid(), 'new@example.com', 'US', 'NYC');

        INSERT INTO user_by_email(email, user_id)
        VALUES ('new@example.com', uuid());
    END IF
COMMIT TRANSACTION;
```

**Key Benefits:**
- Ensure email uniqueness
- Atomic multi-table updates
- Consistent secondary indexes

## Accurate Counting

### Counter Management Example
Implement accurate counters without using Cassandra's counter type.

```sql
CREATE TABLE counters (
    counter_name text,
    value decimal,
    PRIMARY KEY (counter_name)
) WITH transactional_mode = 'full';

BEGIN TRANSACTION
    UPDATE counters 
    SET value += 1 
    WHERE counter_name='visitors';
COMMIT TRANSACTION;
```

**Key Benefits:**
- Accurate incrementing/decrementing
- No lost updates
- Consistent reads

## Best Practices

1. **Keep Transactions Short**
   - Minimize the number of operations
   - Avoid long-running transactions

2. **Use Appropriate Indexes**
   - Create indexes on frequently queried columns
   - Consider denormalization for performance

3. **Handle Failures**
   - Implement retry logic
   - Use timeouts appropriately
   - Log transaction failures

4. **Monitor Performance**
   - Track transaction latency
   - Monitor conflict rates
   - Adjust based on metrics

## Additional Resources

- Join our [Discord](https://discord.gg/GrRCajJqmQ) for real-time support
- Check out the [Troubleshooting Guide](troubleshooting.md)
- Explore the [Example Code](../examples/)
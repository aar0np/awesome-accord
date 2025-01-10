
# Apache Cassandra as a Transactional Database

## Introduction
Welcome to Apache Cassandra! This guide introduces its transactional capabilities, helping you understand how to leverage these features for robust application development.

## Getting Started
### Setting Up Transactional Tables

You will need a distribution of Apache Cassandra that includes Accord. The Docker image in this repository is purpose built for that. 

When defining tables, you must flag them as having transactional capabilities:
```sql
CREATE TABLE demo.tbl (
    col TEXT PRIMARY KEY
) WITH TRANSACTIONAL_MODE = 'full';
```

#### Transactional Modes:
There are a few modes to know about, but the default you should use is "full"

- `off`: Transactions disabled.
- `unsafe`: Permits non-serial writes but can lead to inconsistencies.
- `full`: Ensures serializable semantics for all queries.

---

## Working with Transactions
### Transaction Syntax
Example:
```sql
BEGIN TRANSACTION
    LET existing_user = (SELECT user FROM demo.users WHERE user = 'demo@example.com');

    IF existing_user IS NULL THEN
        INSERT INTO demo.users (user, first_name, last_name)
            VALUES ('demo@example.com', 'John', 'Doe');
        INSERT INTO demo.folders (user, folder_name)
            VALUES ('demo@example.com', 'Documents');
    END IF
COMMIT TRANSACTION;
```

### Key Points:
- BEGIN TRANSACTION and COMMIT TRANSACTION contain the operations.
- LET syntax allows you to gather the current state while exclusive
- IF statement gives the end user the ability to be selective in what DML is executed based on the data collected in the LET
- Atomic modifications across multiple tables.
- Enforce data relationships via transactions.

---

## Use Cases

### Use Case 1: Accurate Counting
Manage inventory counts with atomic increments and decrements under contention.
```sql
CREATE TABLE ks.products (
    item text,
    inventory_count decimal,
    PRIMARY KEY (item)
) WITH transactional_mode = 'full';

INSERT INTO ks.products(item, inventory_count) VALUES ('PlayStation 5', 100);

-- Increment Inventory
BEGIN TRANSACTION
    UPDATE ks.products SET inventory_count += 1 WHERE item='PlayStation 5';
COMMIT TRANSACTION;

-- Decrement Inventory
BEGIN TRANSACTION
    UPDATE ks.products SET inventory_count -= 1 WHERE item='PlayStation 5';
COMMIT TRANSACTION;
```

---

### Use Case 2: Bank Transfer
Perform atomic transfers between accounts, ensuring funds are either fully moved or not at all.
```sql
CREATE TABLE ks.accounts (
    account_holder text,
    account_balance decimal,
    PRIMARY KEY (account_holder)
) WITH transactional_mode = 'full';

INSERT INTO ks.accounts(account_holder, account_balance) VALUES ('bob', 100);
INSERT INTO ks.accounts(account_holder, account_balance) VALUES ('alice', 100);

BEGIN TRANSACTION
    LET fromBalance = (SELECT account_balance FROM ks.accounts WHERE account_holder='alice');

    IF fromBalance.account_balance >= 20 THEN
        UPDATE ks.accounts SET account_balance -= 20 WHERE account_holder='alice';
        UPDATE ks.accounts SET account_balance += 20 WHERE account_holder='bob';
    END IF
COMMIT TRANSACTION;

-- Verify Balances
SELECT account_balance FROM ks.accounts WHERE account_holder='alice';
SELECT account_balance FROM ks.accounts WHERE account_holder='bob';
```

---

### Use Case 3: Inventory Management
Avoid race conditions while managing inventory in distributed systems.
```sql
CREATE TABLE ks.products (
    item text,
    inventory_count decimal,
    PRIMARY KEY (item)
) WITH transactional_mode = 'full';

CREATE TABLE ks.shopping_cart (
    user_name text,
    item text,
    item_count decimal,
    PRIMARY KEY (user_name, item)
) WITH transactional_mode = 'full';

INSERT INTO ks.products(item, inventory_count) VALUES ('PlayStation 5', 100);

BEGIN TRANSACTION
    LET inventory = (SELECT inventory_count FROM ks.products WHERE item='PlayStation 5');

    IF inventory.inventory_count > 0 THEN
        UPDATE ks.products SET inventory_count -= 1 WHERE item='PlayStation 5';
        INSERT INTO ks.shopping_cart(user_name, item, item_count) VALUES ('patrick', 'PlayStation 5', 1);
    END IF
COMMIT TRANSACTION;
```

---

### Use Case 4: Real Atomic Batch
Store and retrieve user data across multiple tables with atomic updates.
```sql
CREATE TABLE ks.user (
    user_id UUID,
    email text,
    country text,
    city text,
    PRIMARY KEY (user_id)
) WITH transactional_mode = 'full';

CREATE TABLE ks.user_by_email (
    email text,
    user_id UUID,
    PRIMARY KEY (email)
) WITH transactional_mode = 'full';

CREATE TABLE ks.user_by_location (
    country text,
    city text,
    user_id UUID,
    PRIMARY KEY ((country, city), user_id)
) WITH transactional_mode = 'full';

BEGIN TRANSACTION
    LET existCheck = (SELECT user_id FROM ks.user_by_email WHERE email='patrick@datastax.com');

    IF existCheck IS NULL THEN
        INSERT INTO ks.user(user_id, email, country, city)
        VALUES (94813846-4366-11ed-b878-0242ac120002, 'patrick@datastax.com', 'US', 'Windsor');

        INSERT INTO ks.user_by_email(email, user_id)
        VALUES ('patrick@datastax.com', 94813846-4366-11ed-b878-0242ac120002);

        INSERT INTO ks.user_by_location(country, city, user_id)
        VALUES ('US', 'Windsor', 94813846-4366-11ed-b878-0242ac120002);
    END IF
COMMIT TRANSACTION;

SELECT * FROM ks.user;
```

---

## Conclusion
Apache Cassandra's transactional capabilities simplify building scalable, reliable applications. Explore these features to enhance your application's consistency and performance.


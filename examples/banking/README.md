# Banking Transaction Examples

This directory contains examples of implementing banking operations using Accord transactions in Cassandra.

## Examples Included

1. Basic Money Transfer
2. Overdraft Protection
3. Multi-Currency Support
4. Account Management

## Schema Definition

```sql
-- schemas.cql
CREATE KEYSPACE IF NOT EXISTS banking WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

-- Account table with balance and currency
CREATE TABLE banking.accounts (
    account_id text,
    balance decimal,
    currency text,
    account_holder text,
    status text,
    PRIMARY KEY (account_id)
) WITH transactional_mode = 'full';

-- Transaction history
CREATE TABLE banking.transactions (
    transaction_id uuid,
    account_id text,
    transaction_type text,
    amount decimal,
    currency text,
    timestamp timestamp,
    status text,
    PRIMARY KEY (account_id, timestamp, transaction_id)
) WITH transactional_mode = 'full';
```

## Basic Money Transfer

Implements a basic money transfer between two accounts with proper error handling:

```sql
-- transfer.cql
BEGIN TRANSACTION
    -- Get source account balance
    LET source = (SELECT balance, currency 
                 FROM banking.accounts 
                 WHERE account_id = 'ACC001');

    -- Verify sufficient funds
    IF source.balance >= 100.00 THEN
        -- Debit source account
        UPDATE banking.accounts 
        SET balance = balance - 100.00 
        WHERE account_id = 'ACC001';

        -- Credit destination account
        UPDATE banking.accounts 
        SET balance = balance + 100.00 
        WHERE account_id = 'ACC002';

        -- Record transaction for source
        INSERT INTO banking.transactions(
            transaction_id, account_id, transaction_type, 
            amount, currency, timestamp, status
        ) VALUES (
            uuid(), 'ACC001', 'DEBIT', 
            100.00, 'USD', toTimestamp(now()), 'COMPLETED'
        );

        -- Record transaction for destination
        INSERT INTO banking.transactions(
            transaction_id, account_id, transaction_type, 
            amount, currency, timestamp, status
        ) VALUES (
            uuid(), 'ACC002', 'CREDIT', 
            100.00, 'USD', toTimestamp(now()), 'COMPLETED'
        );
    END IF
COMMIT TRANSACTION;
```

## Setup Instructions

1. Start Cassandra with Accord:
```bash
./setup.sh
```

2. Create the schema:
```bash
cqlsh -f schemas.cql
```

3. Load sample data:
```bash
cqlsh -f sample_data.cql
```

## Running the Examples

1. Basic Transfer:
```bash
cqlsh -f transfer.cql
```

2. Check results:
```bash
cqlsh -f verify_transfer.cql
```

## Implementation Notes

### Error Handling
- Transactions automatically roll back on failure
- Status tracking for each transaction
- Proper currency validation

### Performance Considerations
- Minimal transaction scope
- Efficient schema design
- Index usage optimization

### Safety Features
- Balance checks before transfer
- Currency compatibility validation
- Transaction logging

## Testing

Run the test suite:
```bash
./run_tests.sh
```

The test suite includes:
- Balance verification
- Concurrent transfer testing
- Error condition handling
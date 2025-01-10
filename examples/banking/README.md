# Banking Transaction Example

This example demonstrates atomic bank transfers using Apache Cassandra's ACID transaction capabilities via Accord. It showcases how to maintain consistency when moving money between accounts.

## Overview

The example implements a basic banking system with:
- Account management with transactional support
- Atomic transfers between accounts
- Balance verification before transfers
- Automatic rollback on failures

## Schema

```sql
CREATE KEYSPACE IF NOT EXISTS banking 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE banking.accounts (     
    account_holder text,
    account_balance decimal,
    PRIMARY KEY (account_holder)
) WITH transactional_mode = 'full';
```

## Quick Start

1. Run the setup script:
```bash
./setup.sh
```

This will:
- Start a Cassandra container with Accord support
- Create the banking keyspace and tables
- Load sample account data
- Verify the setup

2. Execute a transfer:
```bash
docker exec -i cassandra-accord cqlsh < transfer.cql
```

## Included Files

- `schemas.cql`: Table definitions
- `sample_data.cql`: Initial account data (Bob and Alice with $100 each)
- `transfer.cql`: Example transfer transaction ($20 from Alice to Bob)
- `setup.sh`: Automated setup script

## Example Transfer

The transfer script demonstrates:
- Balance checking before transfer
- Atomic updates to both accounts
- Transaction rollback on insufficient funds

```sql
BEGIN TRANSACTION     
    LET fromBalance = (SELECT account_balance FROM banking.accounts 
                      WHERE account_holder='alice');    
    
    IF fromBalance.account_balance >= 20 THEN        
        UPDATE banking.accounts SET account_balance -= 20 
        WHERE account_holder='alice';        
        UPDATE banking.accounts SET account_balance += 20 
        WHERE account_holder='bob';    
    END IF
COMMIT TRANSACTION;
```

## Implementation Details

- Transactions automatically roll back if any part fails
- Balance checks prevent overdrafts
- All operations are atomic and isolated

## Getting Help

Join our Discord community for support and discussions:
https://discord.gg/GrRCajJqmQ

## Next Steps

Try these scenarios:
- Transfer more money than available
- Run concurrent transfers
- Verify final balances
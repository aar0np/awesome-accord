# Quick Start with Accord Transactions

This guide will get you up and running with Accord transactions in minutes. We'll cover setup, basic usage, and your first transaction.

## Prerequisites

- Docker or Podman installed (for single-node testing)
- OR Homebrew (for multi-node setup)
- Basic familiarity with CQL

## Setup Options

### Option 1: Docker (Single Node)
```bash
# Pull and run the container
docker pull pmcfadin/cassandra-accord
docker run -d --name cassandra-accord -p 9042:9042 pmcfadin/cassandra-accord

# Connect with cqlsh
docker exec -it cassandra-accord ./bin/cqlsh
```

### Option 2: Podman (Single Node)
```bash
# Pull and run the container
podman pull pmcfadin/cassandra-accord
podman run -d --name cassandra-accord -p 9042:9042 pmcfadin/cassandra-accord

# Connect with cqlsh
podman exec -it cassandra-accord ./bin/cqlsh
```

### Option 3: Multi-Node Lab (via easy-cass-lab)
```bash
# Install easy-cass-lab
brew tap rustyrazorblade/rustyrazorblade
brew install easy-cass-lab

# Create a new cluster
mkdir my-cluster && cd my-cluster
easy-cass-lab init -c 3 -s 1 mycluster
easy-cass-lab up
```

## Your First Transaction

Let's create a simple inventory management system:

```sql
-- Create a table with transactions enabled
CREATE TABLE demo.products (
    item text,
    inventory_count decimal,
    PRIMARY KEY (item)
) WITH transactional_mode = 'full';

-- Insert initial inventory
INSERT INTO demo.products(item, inventory_count) 
VALUES ('PlayStation 5', 100);

-- Run a transaction to update inventory
BEGIN TRANSACTION
    UPDATE demo.products 
    SET inventory_count -= 1 
    WHERE item='PlayStation 5';
COMMIT TRANSACTION;

-- Verify the result
SELECT * FROM demo.products WHERE item='PlayStation 5';
```

## Example Transactions

1. **Bank Transfer**
```sql
BEGIN TRANSACTION
    UPDATE accounts SET balance -= 100 WHERE user_id = 'alice';
    UPDATE accounts SET balance += 100 WHERE user_id = 'bob';
COMMIT TRANSACTION;
```

2. **User Registration**
```sql
BEGIN TRANSACTION
    LET existing = (SELECT email FROM users WHERE email = 'new@example.com');
    
    IF existing IS NULL THEN
        INSERT INTO users(id, email) VALUES (uuid(), 'new@example.com');
    END IF
COMMIT TRANSACTION;
```

## Next Steps

- Explore more [Use Cases](use-cases.md)
- Learn about [Transaction Patterns](patterns.md)
- Read about [Performance Tuning](performance.md)
- Join our [Discord](https://discord.gg/GrRCajJqmQ) community

## Getting Help
- Check out the [Github Discussions](https://github.com/pmcfadin/awesome-accord/) in the repository
- Check our [Troubleshooting](troubleshooting.md) guide
- Ask in our [Discord](https://discord.gg/GrRCajJqmQ) channel
- Review [Common Issues](troubleshooting.md#common-issues)
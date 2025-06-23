# Cassandra Accord Docker

Run Apache Cassandra with ACID transactions using the Accord protocol. This Docker setup provides a ready-to-use environment for development and testing.

## Prerequisites
- Docker
- Git
- Ant (for building Cassandra)

## Building

First, build Cassandra with Accord:
```bash
# Clone Cassandra
git clone https://github.com/apache/cassandra.git
cd cassandra

# Checkout Accord branch
git checkout cep-15-accord

# Build Cassandra
ant clean
ant
cd ..
```

Then build the Docker image:
```bash
chmod +x build.sh
./build.sh
```

## Running

```bash
# Start a container
docker run -d --name cassandra-accord -p 9042:9042 cassandra-accord

# Connect with cqlsh
docker exec -it cassandra-accord ./bin/cqlsh
```

## Quick Example

```sql
-- Create a table with transactions enabled
CREATE TABLE demo.accounts (
    account_holder text,
    balance decimal,
    PRIMARY KEY (account_holder)
) WITH transactional_mode = 'full';

-- Use transactions
BEGIN TRANSACTION
    UPDATE demo.accounts SET balance -= 100 WHERE account_holder = 'alice';
    UPDATE demo.accounts SET balance += 100 WHERE account_holder = 'bob';
COMMIT TRANSACTION;
```

## Configuration

Environment variables:
- `MAX_HEAP_SIZE` (default: 512M)
- `HEAP_NEWSIZE` (default: 100M)

Example with custom config:
```bash
docker run -d \
  -e MAX_HEAP_SIZE=1G \
  -e HEAP_NEWSIZE=200M \
  -p 9042:9042 \
  cassandra-accord
```

## Community

Join our Discord for support and discussion: [https://discord.gg/GrRCajJqmQ](https://discord.gg/GrRCajJqmQ)

## License

Apache License 2.0
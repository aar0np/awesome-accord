#!/bin/bash

# Test script for Accord transactions in Cassandra
# This script runs a series of tests to verify transaction functionality

echo "Testing Accord Transactions..."

# Wait for Cassandra to be ready
while ! docker exec cassandra-accord cqlsh -e "describe keyspaces" > /dev/null 2>&1; do
    echo "⏳ Waiting for Cassandra to start..."
    sleep 5
done

echo "✅ Cassandra is ready!"

# Create test keyspace and table
docker exec cassandra-accord cqlsh -e "
CREATE KEYSPACE IF NOT EXISTS demo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE IF NOT EXISTS demo.products (
    item text,
    inventory_count decimal,
    PRIMARY KEY (item)
) WITH transactional_mode = 'full';
"

echo "Created test table"

# Insert test data
docker exec cassandra-accord cqlsh -e "
INSERT INTO demo.products(item, inventory_count) VALUES ('test_item', 100);
"

echo "Inserted test data"

# Run test transaction
docker exec cassandra-accord cqlsh -e "
BEGIN TRANSACTION
    UPDATE demo.products SET inventory_count -= 1 WHERE item='test_item';
COMMIT TRANSACTION;
"

echo "Executed test transaction"

# Verify result
RESULT=$(docker exec cassandra-accord cqlsh -e "SELECT inventory_count FROM demo.products WHERE item='test_item';" | grep -A 1 inventory_count | tail -n 1)

if [ "$RESULT" = " 99" ]; then
    echo "✅ Transaction test passed!"
else
    echo "❌ Transaction test failed!"
    exit 1
fi
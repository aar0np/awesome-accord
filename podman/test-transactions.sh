#!/bin/bash

# Test script for Accord transactions in Cassandra
# This script runs a series of tests to verify transaction functionality

echo "Testing Accord Transactions..."

# Wait for Cassandra to be ready
while ! podman exec cassandra-accord ./bin/cqlsh -e "describe keyspaces" > /dev/null 2>&1; do
    echo "⏳ Waiting for Cassandra to start..."
    sleep 5
done

echo "✅ Cassandra is ready!"

# Create test keyspace and table
podman exec cassandra-accord ./bin/cqlsh << EOF
CREATE KEYSPACE IF NOT EXISTS demo 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE IF NOT EXISTS demo.products (
    item text,
    inventory_count decimal,
    PRIMARY KEY (item)
) WITH transactional_mode = 'full';
EOF

echo "Created test table"

# Insert test data
podman exec cassandra-accord ./bin/cqlsh << EOF
INSERT INTO demo.products(item, inventory_count) 
VALUES ('test_item', 100);
EOF

echo "Inserted test data"

# Run test transaction
podman exec cassandra-accord ./bin/cqlsh << EOF
BEGIN TRANSACTION
    UPDATE demo.products 
    SET inventory_count -= 1 
    WHERE item='test_item';
COMMIT TRANSACTION;
EOF

echo "Executed test transaction"

# Verify result
RESULT=$(podman exec cassandra-accord ./bin/cqlsh -e "SELECT inventory_count FROM demo.products WHERE item='test_item'" | grep -A 2 inventory_count | tail -n 1 | tr -d ' ')

echo "Result: $RESULT"

if [ "$RESULT" = "99" ]; then
    echo "✅ Transaction test passed!"
else
    echo "❌ Transaction test failed!"
    echo "Expected: 99"
    echo "Got: $RESULT"
    exit 1
fi
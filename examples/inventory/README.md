# Cassandra ACID Transactions: Inventory Management Example

This example demonstrates how to implement a robust inventory management system using Apache Cassandra's ACID transactions. The example showcases how to handle concurrent inventory updates while maintaining data consistency.

## Overview

The example implements two main tables:
- `products`: Stores product information and inventory counts
- `shopping_cart`: Tracks items added to user shopping carts

Key features demonstrated:
- Atomic inventory updates
- Race condition prevention
- Shopping cart management
- Transactional consistency across tables

## Prerequisites

- Docker installed on your system
- Basic understanding of CQL (Cassandra Query Language)

## Quick Start

1. Run the setup script:
```bash
./setup.sh
```

This will:
- Start a Cassandra container with Accord transactions enabled
- Create the necessary schema
- Load sample data
- Verify the setup

2. Try the example transaction:
```bash
docker exec -i cassandra-accord ./bin/cqlsh < transaction.cql
```

## Files Included

- `schemas.cql`: Table definitions
- `sample_data.cql`: Initial data load
- `transaction.cql`: Example transaction
- `setup.sh`: Setup script

## Join Our Community!

Have questions or want to learn more about Cassandra transactions? Join our Discord community:
https://discord.gg/GrRCajJqmQ

## Next Steps

- Explore other transaction examples in this repository
- Try modifying the inventory counts and observe ACID properties
- Implement your own transactional workflows
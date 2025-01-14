# User Management with Cassandra ACID Transactions

This example demonstrates how to implement a robust user management system using Cassandra's ACID transaction capabilities. The example showcases managing user data across multiple tables while maintaining consistency and preventing duplicate email registrations.

## Overview

The example implements:
- Primary user storage with UUID-based lookups
- Email-based user lookups
- Location-based user lookups
- Atomic updates across all tables
- Duplicate email prevention

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

## Schema Design

The example uses three tables:
- `users.user`: Primary user storage
- `users.user_by_email`: Email lookup index
- `users.user_by_location`: Location-based lookup index

## Files Included

- `setup.sh`: Setup script for running the example
- `schemas.cql`: Table definitions
- `sample_data.cql`: Sample user data
- `queries.cql`: Example transactional queries

## Try It Out

After running setup.sh, you can:
1. Query users by ID
2. Look up users by email
3. Find users by location
4. Add new users atomically

Example query:
```sql
SELECT * FROM users.user_by_email WHERE email='patrick@datastax.com';
```

## Join Our Community

Have questions or want to learn more about Cassandra transactions? 
Check out the [Github Discussions](https://github.com/pmcfadin/awesome-accord/) in the repository or...

Join our Discord community:
https://discord.gg/GrRCajJqmQ

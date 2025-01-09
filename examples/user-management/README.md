# User Management Examples

This directory contains examples of implementing user management operations using Accord transactions in Cassandra. These examples demonstrate maintaining consistency across multiple tables and indexes.

## Use Cases Covered

1. User Registration
   - Email uniqueness validation
   - Multiple table updates
   - Secondary indexes

2. Profile Management
   - Profile updates
   - Email changes
   - Location updates

3. Session Management
   - Session creation
   - Session validation
   - Session cleanup

## Schema Definition

```sql
-- schemas.cql
CREATE KEYSPACE IF NOT EXISTS users WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

-- Primary user table
CREATE TABLE users.user_profile (
    user_id uuid,
    email text,
    first_name text,
    last_name text,
    country text,
    city text,
    created_at timestamp,
    updated_at timestamp,
    status text,
    PRIMARY KEY (user_id)
) WITH transactional_mode = 'full';

-- Email lookup table
CREATE TABLE users.user_by_email (
    email text,
    user_id uuid,
    PRIMARY KEY (email)
) WITH transactional_mode = 'full';

-- Location-based lookup
CREATE TABLE users.user_by_location (
    country text,
    city text,
    user_id uuid,
    PRIMARY KEY ((country, city), user_id)
) WITH transactional_mode = 'full';

-- Session management
CREATE TABLE users.sessions (
    session_id text,
    user_id uuid,
    created_at timestamp,
    expires_at timestamp,
    last_active timestamp,
    status text,
    PRIMARY KEY (session_id)
) WITH transactional_mode = 'full';
```

## Key Operations

### User Registration
```sql
BEGIN TRANSACTION
    -- Check for existing email
    LET existing = (SELECT user_id FROM users.user_by_email 
                   WHERE email = 'new@example.com');

    IF existing IS NULL THEN
        -- Create new user
        LET user_id = uuid();
        
        INSERT INTO users.user_profile(
            user_id, email, first_name, last_name,
            country, city, created_at, updated_at, status
        ) VALUES (
            user_id, 'new@example.com', 'John', 'Doe',
            'US', 'New York', toTimestamp(now()),
            toTimestamp(now()), 'ACTIVE'
        );

        -- Create email lookup
        INSERT INTO users.user_by_email(email, user_id)
        VALUES ('new@example.com', user_id);

        -- Create location lookup
        INSERT INTO users.user_by_location(country, city, user_id)
        VALUES ('US', 'New York', user_id);
    END IF
COMMIT TRANSACTION;
```

### Email Update
```sql
BEGIN TRANSACTION
    -- Check if new email is available
    LET check_email = (SELECT user_id FROM users.user_by_email 
                      WHERE email = 'new@example.com');

    IF check_email IS NULL THEN
        -- Get current user data
        LET user = (SELECT email FROM users.user_profile 
                   WHERE user_id = user_id_var);

        -- Update main profile
        UPDATE users.user_profile 
        SET email = 'new@example.com',
            updated_at = toTimestamp(now())
        WHERE user_id = user_id_var;

        -- Remove old email lookup
        DELETE FROM users.user_by_email 
        WHERE email = user.email;

        -- Add new email lookup
        INSERT INTO users.user_by_email(email, user_id)
        VALUES ('new@example.com', user_id_var);
    END IF
COMMIT TRANSACTION;
```

## Setup Instructions

1. Start Cassandra:
```bash
./setup.sh
```

2. Load sample data:
```bash
cqlsh -f sample_data.cql
```

## Running the Examples

Execute specific operations:
```bash
# Register new user
./run_example.sh register_user.cql

# Update profile
./run_example.sh update_profile.cql

# Verify results
./run_example.sh verify_user.cql
```

## Implementation Notes

### Data Consistency
- Email uniqueness enforcement
- Atomic multi-table updates
- Secondary index maintenance

### Performance Considerations
- Denormalized data for efficient queries
- Minimal transaction scope
- Index optimization

### Security Features
- Session management
- Status tracking
- Audit timestamps

## Testing

Run the test suite:
```bash
./run_tests.sh
```

Tests cover:
- User registration scenarios
- Profile updates
- Email uniqueness
- Session management
- Concurrent operations
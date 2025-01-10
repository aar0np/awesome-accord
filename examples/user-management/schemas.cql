-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS users
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Primary user table
CREATE TABLE users.user (
    user_id UUID,
    email text,
    country text,
    city text,
    PRIMARY KEY (user_id)
) WITH transactional_mode = 'full';

-- Email lookup table
CREATE TABLE users.user_by_email (   
    email text,
    user_id UUID,
    PRIMARY KEY (email)
) WITH transactional_mode = 'full';

-- Location lookup table
CREATE TABLE users.user_by_location (   
    country text, 
    city text,
    user_id UUID, 
    PRIMARY KEY ((country, city), user_id)
) WITH transactional_mode = 'full';
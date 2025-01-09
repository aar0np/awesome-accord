-- Sample data for user management examples

-- Insert sample users
INSERT INTO users.user_profile(
    user_id, email, first_name, last_name,
    country, city, created_at, updated_at, status
) VALUES (
    uuid(), 'alice@example.com', 'Alice', 'Johnson',
    'US', 'New York', toTimestamp(now()),
    toTimestamp(now()), 'ACTIVE'
);

INSERT INTO users.user_profile(
    user_id, email, first_name, last_name,
    country, city, created_at, updated_at, status
) VALUES (
    uuid(), 'bob@example.com', 'Bob', 'Smith',
    'UK', 'London', toTimestamp(now()),
    toTimestamp(now()), 'ACTIVE'
);

-- Insert email lookups
INSERT INTO users.user_by_email(email, user_id)
SELECT email, user_id FROM users.user_profile;

-- Insert location lookups
INSERT INTO users.user_by_location(country, city, user_id)
SELECT country, city, user_id FROM users.user_profile;

-- Insert sample sessions
INSERT INTO users.sessions(
    session_id, user_id, created_at,
    expires_at, last_active, status
) VALUES (
    'sess_001',
    (SELECT user_id FROM users.user_by_email WHERE email = 'alice@example.com'),
    toTimestamp(now()),
    toTimestamp(now() + 3600),
    toTimestamp(now()),
    'ACTIVE'
);
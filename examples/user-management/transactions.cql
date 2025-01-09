-- Common user management transactions

-- Register new user
BEGIN TRANSACTION
    -- Check for existing email
    LET existing = (SELECT user_id FROM users.user_by_email 
                   WHERE email = 'carol@example.com');

    IF existing IS NULL THEN
        -- Create new user
        LET user_id = uuid();
        
        INSERT INTO users.user_profile(
            user_id, email, first_name, last_name,
            country, city, created_at, updated_at, status
        ) VALUES (
            user_id, 'carol@example.com', 'Carol', 'White',
            'CA', 'Toronto', toTimestamp(now()),
            toTimestamp(now()), 'ACTIVE'
        );

        INSERT INTO users.user_by_email(email, user_id)
        VALUES ('carol@example.com', user_id);

        INSERT INTO users.user_by_location(country, city, user_id)
        VALUES ('CA', 'Toronto', user_id);
    END IF
COMMIT TRANSACTION;

-- Update user profile
BEGIN TRANSACTION
    -- Get user ID from email
    LET user = (SELECT user_id FROM users.user_by_email 
                WHERE email = 'alice@example.com');

    IF user IS NOT NULL THEN
        -- Update profile
        UPDATE users.user_profile 
        SET city = 'Chicago',
            country = 'US',
            updated_at = toTimestamp(now())
        WHERE user_id = user.user_id;

        -- Remove old location lookup
        DELETE FROM users.user_by_location 
        WHERE country = 'US' 
        AND city = 'New York' 
        AND user_id = user.user_id;

        -- Add new location lookup
        INSERT INTO users.user_by_location(country, city, user_id)
        VALUES ('US', 'Chicago', user.user_id);
    END IF
COMMIT TRANSACTION;

-- Create user session
BEGIN TRANSACTION
    LET user = (SELECT user_id FROM users.user_by_email 
                WHERE email = 'bob@example.com');

    IF user IS NOT NULL THEN
        INSERT INTO users.sessions(
            session_id, user_id, created_at,
            expires_at, last_active, status
        ) VALUES (
            'sess_002',
            user.user_id,
            toTimestamp(now()),
            toTimestamp(now() + 3600),
            toTimestamp(now()),
            'ACTIVE'
        );
    END IF
COMMIT TRANSACTION;

-- Clean expired sessions
BEGIN TRANSACTION
    -- Find expired sessions
    LET expired = (SELECT session_id 
                  FROM users.sessions 
                  WHERE expires_at < toTimestamp(now()));

    IF expired IS NOT NULL THEN
        UPDATE users.sessions 
        SET status = 'EXPIRED' 
        WHERE session_id = expired.session_id;
    END IF
COMMIT TRANSACTION;
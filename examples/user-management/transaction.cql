-- Add a new user with duplicate email check
BEGIN TRANSACTION   
    -- Find any existing users with same email
    LET existCheck = (SELECT user_id FROM users.user_by_email WHERE email='patrick@datastax.com');
    
    -- If email isn't in use, then add the new user
    IF existCheck IS NULL THEN       
        INSERT INTO users.user(user_id, email, country, city)      
        VALUES (94813846-4366-11ed-b878-0242ac120002, 'patrick@datastax.com', 'US', 'Windsor');
        
        INSERT INTO users.user_by_email(email, user_id) 
        VALUES ('patrick@datastax.com', 94813846-4366-11ed-b878-0242ac120002);         
        
        INSERT INTO users.user_by_location(country, city, user_id)         
        VALUES ('US', 'Windsor', 94813846-4366-11ed-b878-0242ac120002);     
    END IF 
COMMIT TRANSACTION;

-- Query user by email
SELECT * FROM users.user_by_email WHERE email='patrick@datastax.com';

-- Find users in a specific location
SELECT * FROM users.user_by_location WHERE country='US' AND city='Windsor';
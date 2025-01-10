-- Insert first user
INSERT INTO users.user(user_id, email, country, city)
VALUES (a5a13946-4366-11ed-b878-0242ac120003, 'jane@example.com', 'UK', 'London');

INSERT INTO users.user_by_email(email, user_id)
VALUES ('jane@example.com', a5a13946-4366-11ed-b878-0242ac120003);

INSERT INTO users.user_by_location(country, city, user_id)
VALUES ('UK', 'London', a5a13946-4366-11ed-b878-0242ac120003);
-- Sample data for banking examples

-- Create test accounts
INSERT INTO banking.accounts(account_id, balance, currency, account_holder, status)
VALUES ('ACC001', 1000.00, 'USD', 'Alice Johnson', 'ACTIVE');

INSERT INTO banking.accounts(account_id, balance, currency, account_holder, status)
VALUES ('ACC002', 500.00, 'USD', 'Bob Smith', 'ACTIVE');

INSERT INTO banking.accounts(account_id, balance, currency, account_holder, status)
VALUES ('ACC003', 1500.00, 'EUR', 'Carol White', 'ACTIVE');

-- Insert some historical transactions
INSERT INTO banking.transactions(
    transaction_id, account_id, transaction_type, 
    amount, currency, timestamp, status
) VALUES (
    uuid(), 'ACC001', 'CREDIT', 
    1000.00, 'USD', toTimestamp(now()), 'COMPLETED'
);

INSERT INTO banking.transactions(
    transaction_id, account_id, transaction_type, 
    amount, currency, timestamp, status
) VALUES (
    uuid(), 'ACC002', 'CREDIT', 
    500.00, 'USD', toTimestamp(now()), 'COMPLETED'
);

INSERT INTO banking.transactions(
    transaction_id, account_id, transaction_type, 
    amount, currency, timestamp, status
) VALUES (
    uuid(), 'ACC003', 'CREDIT', 
    1500.00, 'EUR', toTimestamp(now()), 'COMPLETED'
);
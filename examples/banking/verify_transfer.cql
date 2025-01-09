-- Verify account balances
SELECT account_id, balance, currency 
FROM banking.accounts 
WHERE account_id IN ('ACC001', 'ACC002');

-- Show recent transactions
SELECT account_id, transaction_type, amount, status 
FROM banking.transactions 
WHERE account_id IN ('ACC001', 'ACC002')
ORDER BY timestamp DESC
LIMIT 10;
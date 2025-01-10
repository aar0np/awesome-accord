-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS banking 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

-- Create accounts table with transactional support
CREATE TABLE IF NOT EXISTS banking.accounts (     
    account_holder text,
    account_balance decimal,
    PRIMARY KEY (account_holder)
) WITH transactional_mode = 'full';
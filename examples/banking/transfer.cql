BEGIN TRANSACTION     
    -- Get the balance from Alices account and store as a Tuple     
    LET fromBalance = (SELECT account_balance FROM banking.accounts WHERE account_holder='alice');    
    
    -- Return the balance before update after transaction complete     
    SELECT account_balance FROM banking.accounts WHERE account_holder='alice';     
    
    -- If Alices account balance is greater than $20, move $20 to Bob     
    IF fromBalance.account_balance >= 20 THEN        
        UPDATE banking.accounts SET account_balance -= 20 WHERE account_holder='alice';        
        UPDATE banking.accounts SET account_balance +=20 WHERE account_holder='bob';    
    END IF
COMMIT TRANSACTION;

-- Show the money was moved 
SELECT account_balance FROM banking.accounts WHERE account_holder='alice';
SELECT account_balance FROM banking.accounts WHERE account_holder='bob';
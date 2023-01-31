--Task 1 Create Table logs

CREATE TABLE Logs (
    LogId INT NOT NULL IDENTITY(1, 1),
    AccountId INT NOT NULL,
    OldSum DECIMAL(18, 2),
    NewSum DECIMAL(18, 2),

    CONSTRAINT PK_Logs PRIMARY KEY (LogId),
    CONSTRAINT FK_Logs_Accounts FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
)

CREATE TRIGGER tr_ChangeBalance
ON Accounts
AFTER UPDATE
AS
BEGIN
    INSERT INTO Logs (AccountId, OldSum, NewSum)
         SELECT i.AccountHolderId,
                d.Balance,
                i.Balance
           FROM INSERTED i
     INNER JOIN DELETED d
             ON d.AccountHolderId = i.AccountHolderId
END


--Task 2 Create Table Emails


--Task 3 Deposit Money

--Task 4 Withdraw Money

--Task 5 Money Transfer

--Task 6 Trigger

--Task 7 Massive Shopping

--Task 8 Employees with Three Projects

--Task 9 Delete Employees




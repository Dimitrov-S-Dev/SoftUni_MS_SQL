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

CREATE TABLE NotificationEmails (
    Id INT NOT NULL IDENTITY(1, 1),
    Recipient INT NOT NULL,
    Subject NVARCHAR(50) NOT NULL,
    Body NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_NotificationEmails PRIMARY KEY (Id),
    CONSTRAINT FK_NotificationEmails_Accounts FOREIGN KEY (Recipient) REFERENCES Accounts (Id)
)
GO

CREATE TRIGGER tr_EmailNotification
ON Logs
AFTER INSERT
AS
BEGIN
    INSERT INTO NotificationEmails (Recipient, Subject, Body)
         SELECT i.AccountId,
                CONCAT('Balance change for account: ', i.AccountId),
                CONCAT('On ', GETDATE(), ' your balance was changed from ', i.OldSum, ' to ', i.NewSum, '.')
           FROM INSERTED i
END


--Task 3 Deposit Money

CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4))
AS
BEGIN
    BEGIN TRANSACTION
        UPDATE Accounts
           SET Balance += @MoneyAmount
         WHERE Id = @AccountId
    COMMIT
END


--Task 4 Withdraw Money

CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4))
AS
BEGIN
    BEGIN TRANSACTION
        UPDATE Accounts
           SET Balance -= @MoneyAmount
         WHERE Id = @AccountId
    COMMIT
END

--Task 5 Money Transfer

CREATE PROC usp_TransferMoney (@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18, 4))
AS
BEGIN
    BEGIN TRANSACTION
        IF (@Amount <= 0)
        BEGIN
            RAISERROR('Amount cannot be negative or zero', 16, 1)
            ROLLBACK
            RETURN
        END
        EXEC usp_DepositMoney @ReceiverId, @Amount
        EXEC usp_WithdrawMoney @SenderId, @Amount
        COMMIT
END


--Task 6 Trigger

CREATE TRIGGER tr_UserGameItems
ON UserGameItems
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO UserGameItems
         SELECT i.Id,
                ug.Id
           FROM inserted
      INNER JOIN UsersGames AS ug
             ON UserGameId = ug.Id
     inner JOIN Items AS i
             ON ItemId = i.Id
          WHERE ug.Level >= i.MinLevel
END
GO

    UPDATE UsersGames
       SET Cash += 50000
      FROM UsersGames AS ug
INNER JOIN Users AS u
        ON ug.UserId = u.Id
INNER JOIN Games AS g
        ON ug.GameId = g.Id
     WHERE g.Name = 'Bali'
       AND u.Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos')
GO

CREATE PROC usp_BuyItems(@Username VARCHAR(100))
AS
BEGIN
    DECLARE @UserId INT = (SELECT Id FROM Users WHERE Username = @Username)
    DECLARE @GameId INT = (SELECT Id FROM Games WHERE Name = 'Bali')
    DECLARE @UserGameId INT = (SELECT Id FROM UsersGames WHERE UserId = @UserId AND GameId = @GameId)
    DECLARE @UserGameLevel INT = (SELECT Level FROM UsersGames WHERE Id = @UserGameId)

    DECLARE @counter INT = 251

    WHILE(@counter <= 539)
    BEGIN
        DECLARE @ItemId INT = @counter
        DECLARE @ItemPrice MONEY = (SELECT Price FROM Items WHERE Id = @ItemId)
        DECLARE @ItemLevel INT = (SELECT MinLevel FROM Items WHERE Id = @ItemId)
        DECLARE @UserGameCash MONEY = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)

        IF(@UserGameCash >= @ItemPrice AND @UserGameLevel >= @ItemLevel)
        BEGIN
            UPDATE UsersGames
            SET Cash -= @ItemPrice
            WHERE Id = @UserGameId

            INSERT INTO UserGameItems VALUES
            (@ItemId, @UserGameId)
        END

        SET @counter += 1

        IF(@counter = 300)
        BEGIN
            SET @counter = 501
        END
    END
END


--Task 7 Massive Shopping

--Task 8 Employees with Three Projects

--Task 9 Delete Employees




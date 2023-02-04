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

----------------------------------------------------

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

----------------------------------------------------

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

----------------------------------------------------

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

----------------------------------------------------

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

----------------------------------------------------

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

----------------------------------------------------

--Task 7 Massive Shopping

DECLARE @userName NVARCHAR(max) = 'Stamat'
DECLARE @gameName NVARCHAR(max) = 'Safflower'
DECLARE @userID INT = (
                        SELECT Id
                          FROM Users
                         WHERE Username = @userName
                      )
DECLARE @gameID INT = (
                        SELECT Id
                          FROM Games
                         WHERE Name = @gameName
                      )
DECLARE @userMoney MONEY = (
                        SELECT Cash
                          FROM UsersGames
                         WHERE UserId = @userID AND GameId = @gameID
                      )
DECLARE @itemsTotalPrice MONEY
DECLARE @userGameID int = (
                        SELECT Id
                          FROM UsersGames
                         WHERE UserId = @userID AND GameId = @gameID
                      )

BEGIN TRANSACTION
      SET @itemsTotalPrice = (SELECT SUM(Price)
     FROM Items
    WHERE MinLevel BETWEEN 11 AND 12)

    IF(@userMoney - @itemsTotalPrice >= 0)
    BEGIN
        INSERT INTO UserGameItems
        SELECT i.Id, @userGameID FROM Items AS i
        WHERE i.Id IN (
                        SELECT Id
                          FROM Items
                         WHERE MinLevel BETWEEN 11 AND 12
                      )

        UPDATE UsersGames
        SET Cash -= @itemsTotalPrice
        WHERE GameId = @gameID AND UserId = @userID
        COMMIT
    END
    ELSE
    BEGIN
        ROLLBACK
    END

SET @userMoney = (
                    SELECT Cash
                      FROM UsersGames
                     WHERE UserId = @userID AND GameId = @gameID
                 )
BEGIN TRANSACTION
    SET @itemsTotalPrice = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)

    IF(@userMoney - @itemsTotalPrice >= 0)
    BEGIN
        INSERT INTO UserGameItems
        SELECT i.Id, @userGameID FROM Items AS i
        WHERE i.Id IN (
                        SELECT Id
                          FROM Items
                         WHERE MinLevel BETWEEN 19 AND 21
                      )

        UPDATE UsersGames
        SET Cash -= @itemsTotalPrice
        WHERE GameId = @gameID AND UserId = @userID
        COMMIT
    END
    ELSE
    BEGIN
        ROLLBACK
    END

  SELECT Name AS [Item Name]
    FROM Items
   WHERE Id IN (
                SELECT ItemId
                  FROM UserGameItems
                 WHERE UserGameId = @userGameID
               )
ORDER BY [Item Name]

----------------------------------------------------

--Task 8 Employees with Three Projects

CREATE PROC usp_AssignProject(@EmployeeId INT, @ProjectID INT)
AS
BEGIN
    BEGIN TRANSACTION
    DECLARE @EmployeeProjects INT
    SET @EmployeeProjects = (SELECT COUNT(ep.ProjectID)
                               FROM EmployeesProjects ep
                              WHERE ep.EmployeeID = @EmployeeId)
    IF (@EmployeeProjects >= 3)
    BEGIN
        RAISERROR('The employee has too many projects!', 16, 1)
        ROLLBACK
        RETURN
    END

    INSERT INTO EmployeesProjects (EmployeeID, ProjectID)
         VALUES (@EmployeeId, @ProjectID)
    COMMIT
END

----------------------------------------------------

--Task 9 Delete Employees

CREATE TABLE Deleted_Employees (
    EmployeeId INT NOT NULL IDENTITY(1, 1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    MiddleName NVARCHAR(50),
    JobTitle NVARCHAR(50),
    DepartmentId INT,
    Salary DECIMAL(18, 2),

    CONSTRAINT PK_Deleted_Employees PRIMARY KEY (EmployeeId)
)

CREATE TRIGGER tr_DeleteEmployees
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
         SELECT d.FirstName,
                d.LastName,
                d.MiddleName,
                d.JobTitle,
                d.DepartmentID,
                d.Salary
           FROM DELETED d
END

----------------------------------------------------

--Task 10 People with Balance Higher Than

CREATE PROC usp_GetHoldersWithBalanceHigherThan @TotalMoney DECIMAL(18, 4)
AS
BEGIN
	SELECT
		ah.FirstName, ah.LastName
	FROM Accounts AS a
	JOIN AccountHolders AS ah ON a.AccountHolderId = ah.Id
	GROUP BY ah.FirstName, ah.LastName
	HAVING SUM(a.Balance) > @TotalMoney
	ORDER BY ah.FirstName,
	ah.LastName
END

----------------------------------------------------

-- Task 11 Future Value Function

CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(20,2), @YearlyInterest FLOAT, @Years INT)
RETURNS DECIMAL(20,4) AS
BEGIN
	DECLARE @Result DECIMAL(20,4) = @Sum * POWER((1+@YearlyInterest), @Years)
	RETURN @Result
END

-----------------------------------------------

--Task 12 Calculating Interest

CREATE PROC usp_CalculateFutureValueForAccount (@AccID INT, @InterestRate FLOAT)
AS
SELECT
	a.Id AS [Account Id],
	ah.FirstName AS [First Name],
	ah.LastName AS [Last Name],
	a.Balance AS [Current Balance],
	dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, 5) AS [Balance in 5 years]
FROM AccountHolders AS ah
JOIN Accounts AS a ON a.AccountHolderId=ah.Id AND a.Id = @AccID

-----------------------------------------------

--Task 13 Cash in User Games Odd Rows

CREATE FUNCTION ufn_CashInUsersGames(@GameName NVARCHAR(155))
RETURNS TABLE AS
	RETURN SELECT SUM(Cash) AS SumCash FROM

		(SELECT ug.Cash, ROW_NUMBER() OVER(ORDER BY Cash DESC) AS RowNumber FROM UsersGames AS ug
		JOIN Games AS g ON ug.GameId = g.Id
		WHERE g.Name = @GameName
		) AS AllGames
		WHERE RowNumber % 2 = 1

	--SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')
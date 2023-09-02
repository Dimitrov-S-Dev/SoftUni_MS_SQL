--Task 1 Employees with Salary Above 35000

GO
CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT
		FirstName,
		LastName
	FROM
	    Employees
	WHERE
	    Salary > 35000
END
GO
--Do not paste this in Judge. It's for testing purpose only.
--EXEC dbo.usp_GetEmployeesSalaryAbove35000

----------------------------------------------------

--Task 2 Employees with Salary Above Number

GO
CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAboveNumber @aboveSalary DECIMAL(18, 4)
AS
BEGIN
	SELECT
	    FirstName,
	    LastName
	FROM
	    Employees
	WHERE
	    Salary >= @aboveSalary
END
GO
--Do not paste this in Judge. It's for testing purpose only.
EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100

----------------------------------------------------

--Task 3 Town Names Starting With

GO
CREATE OR ALTER PROCEDURE usp_GetTownsStartingWit @word VARCHAR(20)
AS
BEGIN
	SELECT
	    [Name] AS Town
	FROM
	    Towns as t
	WHERE
	    LEFT(t.Name,LEN(@word)) = @word

END
GO
--Do not paste this in Judge. It's for testing purpose only.
EXEC dbo.usp_GetTownsStartingWit b

----------------------------------------------------

--Task 4 Employees from Town

GO
CREATE OR ALTER PROCEDURE usp_GetEmployeesFromTown @townName VARCHAR(50)
AS
BEGIN
	SELECT
	    FirstName,
	    LastName
	FROM
	    Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID
	JOIN Towns AS t ON a.TownID = t.TownID
	WHERE
	    t.Name = @townName
END
GO

----------------------------------------------------

--Task 5 Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(8)
	IF @salary < 30000
	BEGIN
		SET @salaryLevel = 'Low'
	END
	ELSE IF @salary BETWEEN 30000 AND 50000
	BEGIN
		SET @salaryLevel = 'Average'
	END
	ELSE IF @salary > 50000
	BEGIN
		SET @salaryLevel = 'High'
	END

	RETURN @salaryLevel
END

SELECT
	Salary,
	dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
	FROM Employees

----------------------------------------------------

--Task 6 Employees by Salary Level

GO
CREATE OR ALTER PROCEDURE usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(8)
AS
BEGIN
	SELECT
	    FirstName,
	    LastName
	FROM
	    Employees
	WHERE
	    dbo.GetSalaryLevel(Salary) = @salaryLevel
END
GO

----------------------------------------------------

--Task 7 Define Function

CREATE FUNCTION ufn_isWordComprised (@SetOfLetters VARCHAR(50), @Word VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @Index INT = 1
    WHILE (@Index <= LEN(@Word))
    BEGIN
        DECLARE @SymbolChar CHAR = SUBSTRING(@Word, @Index, 1)
        IF CHARINDEX(@SymbolChar, @SetOfLetters) = 0)
        BEGIN
            RETURN 0
        END
        SET @Index += 1
    END
    RETURN 1
END

----------------------------------------------------

--Task 8 Delete Employees and Departments

CREATE PROC usp_DeleteEmployeesFromDepartment (@DepartmentId INT)
AS
BEGIN
    DECLARE @EmployeesIdToDelete TABLE (Id INT)

    INSERT INTO @EmployeesIdToDelete
         SELECT e.EmployeeID
           FROM Employees e
          WHERE e.DepartmentID = @DepartmentId

     ALTER TABLE Departments
    ALTER COLUMN ManagerID INT NULL

    DELETE FROM EmployeesProjects
          WHERE EmployeeID IN (SELECT Id FROM @EmployeesIdToDelete)

    UPDATE Employees
       SET ManagerID = NULL
     WHERE ManagerID IN (SELECT Id FROM @EmployeesIdToDelete)

    UPDATE Departments
       SET ManagerId = NULL
     WHERE ManagerID IN (SELECT Id FROM @EmployeesIdToDelete)

    DELETE FROM Employees
          WHERE EmployeeID IN (SELECT Id FROM @EmployeesIdToDelete)

    DELETE FROM Departments
          WHERE DepartmentID = @DepartmentId

        SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
    INNER JOIN Departments AS d
            ON d.DepartmentID = e.DepartmentID
         WHERE e.DepartmentID = @DepartmentId
END

----------------------------------------------------

--Task 9 Find Full Name

CREATE PROC usp_GetHoldersFullName
AS
BEGIN
    SELECT ah.FirstName + ' ' + ah.LastName AS [Full Name]
      FROM AccountHolders ah
END

----------------------------------------------------

--Task 10 People with Balance Higher Than

CREATE OR ALTER PROCEDURE usp_GetHoldersWithBalanceHigherThan @amount DECIMAL(18, 4)
AS
BEGIN
	SELECT
	ah.FirstName,
	ah.LastName
	FROM AccountHolders AS ah
	JOIN Accounts AS a ON ah.ID = a.AccountHolderID
	GROUP BY ah.FirstName, ah.LastName
	HAVING SUM(a.Balance) > @amount
	WHERE
END

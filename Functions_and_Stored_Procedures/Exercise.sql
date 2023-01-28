-- Task 1 Employees with Salary Above 35000

GO
CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT
		FirstName,
		LastName
		FROM Employees
		WHERE Salary > 35000
END
GO

--Do not paste this in Judge. It's for testing purpose only.
EXEC dbo.usp_GetEmployeesSalaryAbove35000

-- Task 2 Employees with Salary Above Number

GO
CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAboveNumber @minSalary DECIMAL(18, 4)
AS
BEGIN
	SELECT
	FirstName,
	LastName
	FROM Employees
	WHERE Salary >= @minSalary
END

GO
--Do not paste this in Judge. It's for testing purpose only.
EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100

--Task 3 Town Names Starting With

GO
CREATE OR ALTER PROCEDURE usp_GetTownsStartingWit @townNames VARCHAR(20)
AS
BEGIN
	SELECT
	Name AS Town
	FROM Towns
	WHERE Name LIKE @townNames + '%'

END
GO
--Do not paste this in Judge. It's for testing purpose only.
EXEC dbo.usp_GetTownsStartingWit b

--Task 4 Employees from Town

GO
CREATE OR ALTER PROCEDURE usp_GetEmployeesFromTown @townName VARCHAR(50)
AS
BEGIN
	SELECT
	FirstName,
	LastName
	FROM Employees AS E
	JOIN Addresses AS A ON E.AddressID = A.AddressID
	JOIN Towns AS T ON A.TownID = T.TownID
	WHERE T.Name = @townName
END
GO

-- Task 5 Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(10)

	IF @salary < 30000
	BEGIN
		SET @salaryLevel = 'Low'
	END
	IF @salary BETWEEN 30000 AND 50000
	BEGIN
		SET @salaryLevel = 'Average'
	END
	IF @salary > 50000
	BEGIN
	SET @salaryLevel = 'High'
	END
	RETURN @salaryLevel
END

SELECT
	Salary,
	dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
	FROM Employees

-- Task 6
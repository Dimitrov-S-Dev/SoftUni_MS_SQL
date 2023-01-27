-- Task 1 Employees with Salary Above 35000
GO
CREATE OR ALTER PROCEDURE usp_GetEmployeesSalaryAbove35000
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



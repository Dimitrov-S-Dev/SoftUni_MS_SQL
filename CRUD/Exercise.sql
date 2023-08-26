--Task 2 Find All the Information About Departments

SELECT *
FROM
    Departments
----------------------------------------------------

--Task 3 Find all Department Names

SELECT
    [name]
FROM
    Departments
----------------------------------------------------

--Task 4 Find Salary of Each Employee

SELECT
    [FirstName],
	[LastName],
	[Salary]
FROM
    Employees

-----------------------------------------------

--Task 5 Find Full Name of Each Employee

SELECT
    [FirstName],
	[MiddleName],
	[LastName]
FROM
    Employees

-----------------------------------------------

--Task 6 Find Email Address of Each Employee

SELECT
    CONCAT([FirstName], '.', [LastName], '@', 'softuni.bg')
AS
    [Full Email Address]
FROM
    Employees

-----------------------------------------------

--Task 7 Find All Different Employees’ Salaries

SELECT
DISTINCT
    Salary
FROM
    Employees

-----------------------------------------------

--Task 8 Find All Information About Employees

SELECT
	*
FROM
    Employees
WHERE
    JobTitle = 'Sales Representative'

-----------------------------------------------

--Task 9 Find Names of All Employees by Salary in Range

SELECT
    FirstName,
    LastName,
    JobTitle
FROM
    Employees
WHERE
    Salary BETWEEN 20000 AND 30000

-----------------------------------------------

--Task 10 Find Names of All Employees

SELECT
	CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
AS
    [Full Name]
FROM
    Employees
WHERE
    Salary IN(12500, 14000, 25000, 23600)
    --Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

-----------------------------------------------

--Task 11 Find All Employees Without a Manager

SELECT
    FirstName,
	LastName
FROM
    Employees
WHERE
    ManagerID IS NULL

-----------------------------------------------

--Task 12 Find All Employees with a Salary More Than 50000

SELECT FirstName,
	   LastName,
	   Salary
	FROM Employees
	WHERE Salary > 50000
	ORDER BY Salary DESC

-----------------------------------------------

--Task 13 Find 5 Best Paid Employees

SELECT TOP(5)
	   FirstName,
	   LastName
	FROM Employees
	ORDER BY Salary DESC

-----------------------------------------------

--Task 14 Find All Employees Except Marketing

SELECT FirstName,
	   LastName
	FROM Employees
	WHERE DepartmentID != 4

-----------------------------------------------

--Task 15 Sort Employees Table

SELECT *
	FROM Employees
	ORDER BY Salary DESC,
			FirstName,
			LastName DESC,
			MiddleName

-----------------------------------------------

--Task 16 Create View Employees with Salaries

CREATE VIEW V_EmployeesSalaries AS
	SELECT FirstName,
		   LastName,
		   Salary
		FROM Employees

-----------------------------------------------

--Task 17 Create View Employees with Job Titles

CREATE VIEW V_EmployeeNameJobTitle AS
	SELECT CONCAT(FirstName,' ', MiddleName, ' ', LastName) AS [Full Name],
			JobTitle
		FROM Employees

--CREATE VIEW V_EmployeeNameJobTitle AS
	--SELECT CONCAT_WS(' ',FirstName,MiddleName,LastName) AS [Full Name],
			JobTitle
		FROM Employees

-----------------------------------------------

--Task 18 Distinct Job Titles

SELECT
	DISTINCT JobTitle
	FROM Employees

-----------------------------------------------

--Task 19 Find First 10 Started Projects

SELECT
	TOP(10) *
	FROM Projects
	ORDER BY StartDate,
			 [Name]

-----------------------------------------------

--Task 20 Last 7 Hired Employees

SELECT TOP(7)
		FirstName,
		LastName,
		HireDate
	FROM Employees
	ORDER BY HireDate DESC

-----------------------------------------------

--Task 21 Increase Salaries

UPDATE Employees
	SET Salary *= 1.12
	WHERE DepartmentID IN(1, 4, 2, 11)

SELECT Salary
	FROM Employees

-----------------------------------------------

--Task 22 All Mountain Peaks

SELECT PeakName
	FROM Peaks
	ORDER BY PeakName ASC

-----------------------------------------------

--Task 23 Biggest Countries by Population

SELECT TOP(30)
		CountryName,
		[Population]
	FROM Countries
	WHERE ContinentCode = 'EU'
	ORDER BY [Population] DESC,
			CountryName

-----------------------------------------------

--Task 24 Countries and Currency (Euro / Not Euro)

SELECT CountryName, CountryCode, Currency =
CASE CurrencyCode
WHEN 'EUR' THEN 'Euro'
ELSE 'Not Euro'
END
FROM Countries
ORDER BY CountryName

-----------------------------------------------

--Task 25 All Diablo Characters

USE Diablo

SELECT Name
	FROM Characters
	ORDER BY [Name]

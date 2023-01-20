-- Task 1 Find Names of All Employees by First Name

SELECT FirstName, LastName
	FROM Employees
	--WHERE FirstName LIKE 'Sa%'
	WHERE LEFT(FirstName, 2) = 'Sa'

-- Task 2 Find Names of All employees by Last Name

SELECT FirstName, LastName
	FROM Employees
	--WHERE LastName LIKE '%ei%'
	WHERE CHARINDEX('ei', LastName) <> 0

-- Task 3 Find First Names of All Employees

SELECT FirstName
	FROM Employees
	WHERE DepartmentID IN (3, 10) AND DATEPART(YEAR,HireDate) BETWEEN 1995 AND 2005

-- Task 4 Find All Employees Except Engineers

SELECT FirstName, LastName
	FROM Employees
	WHERE JobTitle NOT LIKE '%engineer%'

-- Task 5 Find Towns with Name Length

SELECT Name
	FROM Towns
	WHERE LEN(Name) IN (5, 6)
	ORDER BY Name

-- Task 6 Find Towns Starting With

SELECT TownID, Name
	FROM Towns
	WHERE LEFT(Name, 1) IN ('M', 'K', 'B', 'E')
	ORDER BY Name


-- Task 7 Find Towns Not Starting With

SELECT TownID, [Name]
	FROM Towns
	WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
	ORDER BY [Name]


-- Task 8 Create View Employees Hired After 2000 Year

CREATE VIEW V_EmployeesHiredAfter2000
AS
SELECT FirstName, LastName
	FROM Employees
	WHERE DATEPART(YEAR, HireDate) > 2000

-- SELECT *
	--FROM v_EmployeesHiredAfter200

-- Task 9 Length of Last Name

SELECT FirstName, LastName
	FROM Employees
	WHERE LEN(LastName) = 5

-- Task 10 Rank Employees by Salary

SELECT   EmployeeID, FirstName, LastName, Salary,
	     DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
	    AS [RANK]
	  FROM Employees
	 WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC


-- Task 11 Find All Employees with Rank 2 *

SELECT *
	FROM (
		SELECT   EmployeeID, FirstName, LastName, Salary,
				 DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
				AS [RANK]
			  FROM Employees
			 WHERE Salary BETWEEN 10000 AND 50000
		) AS RankingSubquary
		WHERE [Rank] = 2
		ORDER BY Salary DESC

-- Task 12 Countries Holding 'A' 3 or More Times

SELECT CountryName, IsoCode
	FROM Countries
	WHERE LOWER(CountryName) LIKE '%a%a%a%'
	ORDER BY IsoCode

-- Task 13 Mix of Peak and River Names

SELECT p.PeakName, r.RiverName,
LOWER(PeakName + SUBSTRING(RiverName, 2, LEN(RiverName) - 1)) AS Mix
	FROM Peaks as p
	JOIN Rivers as r
	ON RIGHT (PeakName,1) = LEFT(RiverName, 1)
	ORDER BY Mix

-- Task 14 Games from 2011 and 2012 year

SELECT TOP(50) [Name], FORMAT([Start],'yyyy-MM-dd') AS [Start]
	FROM Games
	WHERE DATEPART(YEAR, Start) IN (2011, 2012)
	ORDER BY [Start], [Name]

-- Task 15 User Email Providers

SELECT
	Username,
	SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))
	AS [Email Provider]
	FROM Users
	ORDER BY [Email Provider], Username

-- Task 16 Get Users with IPAdress Like Pattern

SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- Task 17 Show All Games with Duration and Part of the Da

SELECT [Name] As Game,
[Part of the Day] =
CASE
	WHEN DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
	ELSE 'Evening'
	END,
Duration =
CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration <= 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	ELSE 'Extra Long'
	END
FROM Games
ORDER BY Game, Duration, [Part of the Day]

-- Task 18 Orders Table

Select
	ProductName,
	OrderDate,
	DATEADD(day, 3, OrderDate) AS [Pay Due],
	DATEADD(Month, 1, OrderDate) AS [Deliver Due]
FROM Orders

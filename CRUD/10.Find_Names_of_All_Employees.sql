-- Task 10 => Find Names of All Employees
-- Create a SQL query that finds the full name of all employees
--whose salary is exactly 25000, 14000, 12500 or 23600.
--The result should be displayed in a column, named "Full Name",
--which is a combination of the first, middle and last names,
--separated by a single space

SELECT
	CONCAT(FirstName,  ' ',  MiddleName, ' ', LastName)
	AS [Full Name]
	FROM Employees
	WHERE Salary = 25000 OR Salary = 14000 OR Salary = 12500 OR Salary = 23600

-- SELECT
--	CONCAT(FirstName, ' ',  MiddleName,  ' ', LastName)
--  AS [Full Name]
--	FROM Employees
--	WHERE Salary IN (25000, 14000, 12500, 23600)

-- SELECT
--	CONCAT_WS(' ', FirstName, MiddleName, LastName)
--  AS [Full Name]
--	FROM Employees
--	WHERE Salary IN (25000, 14000, 12500, 23600)
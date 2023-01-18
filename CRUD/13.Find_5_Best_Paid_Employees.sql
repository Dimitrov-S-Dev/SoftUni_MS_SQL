-- Task 13 => Find 5 Best Paid Employees
-- Create a SQL query that finds the first and last names
--of all employees whose department ID is not 4

SELECT TOP(5)
	   FirstName,
	   LastName
	FROM Employees
	ORDER BY Salary DESC

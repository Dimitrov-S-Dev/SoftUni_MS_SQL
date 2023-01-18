-- Task 9 => Find Names of All Employees by Salary in Range
-- Create a SQL query to find the first name,
--last name and job title for all employees whose salary is in a range
-- between 20000 and 30000.

SELECT
		FirstName,
		LastName,
		JobTitle
	FROM Employees
	WHERE Salary BETWEEN 20000 AND 30000

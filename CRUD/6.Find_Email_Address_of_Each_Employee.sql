-- Task 6 => Find Email Address of Each Employee
--Create a SQL query that finds the email address of each employee by their first and last name.
--Consider that the email domain is softuni.bg.
--Emails should look like "John.Doe@softuni.bg".
--The produced column should be named "Full Email Address".

SELECT
		FirstName + '.' + LastName + '@softuni.bg'
		AS [Full Email Address]
	FROM Employees

-- Task 15 => Sort Employees Table
-- Create a SQL query that sorts all the records
--in the Employees table by the following criteria:
--· By salary in decreasing order
--· Then by the first name alphabetically
--· Then by the last name descending
--· Then by middle name alphabetically

SELECT *
	FROM Employees
	ORDER BY Salary DESC,
			FirstName,
			LastName DESC,
			MiddleName

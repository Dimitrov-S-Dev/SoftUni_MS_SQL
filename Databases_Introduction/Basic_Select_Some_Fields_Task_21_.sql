-- Task 21 => Basic Select Some Fields
--Modify the queries from the previous problem to show only some of the columns.
--For table:
--· Towns – Name
--· Departments – Name
--· Employees – FirstName, LastName, JobTitle, Salary
--Keep the ordering from the previous problem.
--Submit your query statements as Prepare DB & Run queries.

SELECT Name
FROM Towns
ORDER BY Name

SELECT Name
FROM Departments
ORDER BY Name

SELECT FirstName, LastName, JobTitle, Salary
FROM Employees
ORDER BY salary DESC

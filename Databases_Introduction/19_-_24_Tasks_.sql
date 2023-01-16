--Task 19 => Basic Select All Fields
-- Use the SoftUni database and first select all records from the Towns,
--then from Departments and finally from Employees table.
--Use SQL queries and submit them to Judge at once.
--Submit your query statements as Prepare DB & Run queries

SELECT * FROM Towns

SELECT * FROM Departments

SELECT * FROM Employees

-- Task 20 => Basic Select All Fields and Order Them
--Modify the queries from the previous problem by sorting:
--· Towns - alphabetically by name
--· Departments - alphabetically by name
--· Employees - descending by salary

SELECT * FROM Towns
ORDER BY name

SELECT * FROM Departments
ORDER BY name

SELECT * FROM Employees
ORDER BY salary DESC

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

-- Task 22 => Increase Employees Salary
-- Use SoftUni database and increase the salary of all employees by 10%.
--Then show only Salary column for all the records in the Employees table.
--Submit your query statements as Prepare DB & Run queries.

UPDATE Employees
SET Salary *= 1.1

SELECT Salary FROM Employees

-- Task 23 => Decrease Tax Rate
-- Use Hotel database and decrease tax rate by 3% to all payments.
--Then select only TaxRate column from the Payments table.
--Submit your query statements as Prepare DB & Run queries.

UPDATE Payments
SET TaxRate *= 0.97

SELECT TaxRate
FROM
Payments

-- Task 24 => Delete All Records
--Use Hotel database and delete all records from the Occupancies table.
--Use SQL query.
--Submit your query statements as Run skeleton, run queries & check DB

TRUNCATE TABLE Occupancies
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
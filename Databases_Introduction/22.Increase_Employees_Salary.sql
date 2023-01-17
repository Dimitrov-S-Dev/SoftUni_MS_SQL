-- Task 22 => Increase Employees Salary
-- Use SoftUni database and increase the salary of all employees by 10%.
--Then show only Salary column for all the records in the Employees table.
--Submit your query statements as Prepare DB & Run queries.

UPDATE Employees
SET Salary *= 1.1

SELECT Salary FROM Employees

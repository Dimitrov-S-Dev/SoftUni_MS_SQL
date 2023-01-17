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

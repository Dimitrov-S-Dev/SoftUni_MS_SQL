-- Task 1 Employee Address

SELECT
	TOP 5
	e.EmployeeID,
	e.JobTitle,
	e.AddressID,
	a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID = a.AddressID
	ORDER BY e.AddressID

-- Task 2 Addresses with Towns

SELECT
	TOP 50
	e.FirstName,
	e.LastName,
	t.Name AS Town,
	a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID
	JOIN Towns AS t ON a.TownID = t.TownID
	ORDER BY e.FirstName,
		e.LastName


-- Task 3 Sales Employee

SELECT
	e.EmployeeID,
	e.FirstName,
	e.LastName,
	d.Name AS DepartmentName
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'
	ORDER BY e.EmployeeID

-- Task 4 Employee Departments

SELECT
	TOP 5
	e.EmployeeID,
	e.FirstName,
	e.Salary,
	d.Name AS DepartmentName
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE e.Salary > 15000
	ORDER BY e.DepartmentID

--Task 5 Employees without project

SELECT
	TOP 3 e.EmployeeID, e.FirstName
	FROM Employees AS e
	LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	WHERE ep.ProjectID IS NOT NULL
	ORDER BY e.EmployeeID

-- Task 6 Employees hired after

SELECT
	e.FirstName,
	e.LastName,
	e.HireDate,
	d.Name AS DeptName
	FROM Employees AS e
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
	WHERE e.HireDate > 1999/01/01 AND d.Name IN('Sales','Finance')
	ORDER BY e.HireDate



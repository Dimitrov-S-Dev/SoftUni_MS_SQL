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
	WHERE e.HireDate > '1999-01-01' AND d.Name IN('Sales','Finance')
	ORDER BY e.HireDate

-- Task 7 Employee with project

SELECT
	TOP 5
	e.EmployeeID,
	e.FirstName,
	p.Name AS ProjectName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p ON ep.ProjectID = p.ProjectID
	WHERE p.StartDate > '2002-01-13' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID

--Task 8 Employee 24

SELECT
	e.EmployeeID,
	e.FirstName,
	CASE
		WHEN p.StartDate >= '2005-01-01' THEN NULL
		ELSE p.Name
	END AS ProjectName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p ON ep.ProjectID = p.ProjectID
	WHERE e.EmployeeID = 24

-- Task 9 Employee manager

SELECT
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	e2.FirstName AS ManagerName
	FROM Employees AS e
	JOIN Employees AS e2 ON e.ManagerID = e2.EmployeeID
	WHERE e.ManagerID IN(3,7)

--Task 10 Employee summary

SELECT
	TOP 50
	e.EmployeeID,
	CONCAT_WS(' ',e.Firstname,e.LastName) AS EmployeeName,
	CONCAT_WS(' ', e2.FirstName, e2.LastName) AS ManagerName,
	d.Name AS DepartmentName
	FROM Employees AS e
	JOIN Employees AS e2 ON e.ManagerID = e2.EmployeeID
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
	ORDER BY e.EmployeeID



--Task 11 Min average salary

SELECT TOP 1 MinAverageSalary FROM
	(SELECT
	AVG(Salary) AS MinAverageSalary
	FROM Employees
	GROUP BY DepartmentID) AS AvgSalaries
	ORDER BY MinAverageSalary


--Task 12 Highest picks in Bulgaria

SELECT
	c.CountryCode,
	m.MountainRange,
	p.PeakName,
	p.Elevation
	FROM Countries AS c
	JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	JOIN Mountains AS m ON mc.MountainId = m.Id
	JOIN Peaks AS p ON m.Id = p.MountainId
	WHERE p.Elevation > 2835 AND c.CountryCode = 'BG'
	ORDER BY p.Elevation DESC


--Task 13 Count mountain ranges

SELECT
	CountryCode,
	COUNT(MountainId) AS MountainRanges
	FROM MountainsCountries
	WHERE CountryCode IN ('BG','RU','US')
	GROUP BY CountryCode

--Task 14 Countries with Rivers

SELECT
	TOP 5
	c.CountryName,
	r.RiverName
	FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
	WHERE c.ContinentCode = 'AF'
	ORDER BY c.CountryName


-- Task 16 Country without any mountains

SELECT
	COUNT(c.CountryCode) AS COUNT
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	WHERE mc.MountainId IS NULL


--Task 17 Highest peak and longest river by country
	SELECT TOP(5)
		 c.CountryName,
		 MAX(p.Elevation) AS HighestPeakElevation,
		 MAX(r.Length) AS LongestRiverLength
		 FROM Countries AS c
		LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
		LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
		LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN Peaks AS p ON mc.MountainId = p.MountainId
		 GROUP BY c.CountryName
		 ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, CountryName

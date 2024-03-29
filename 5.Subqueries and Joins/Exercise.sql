--Task 1 Employee Address

SELECT TOP 5
       e.EmployeeID,
       e.JobTitle,
       e.AddressID,
       a.AddressText
  FROM Employees AS e
  LEFT JOIN Addresses AS a
    ON e.AddressID = a.AddressID
 ORDER BY e.AddressID

----------------------------------------------------

--Task 2 Addresses with Towns

SELECT TOP 50
       e.FirstName,
       e.LastName,
       t.Name AS Town,
       a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a
    ON e.AddressID = a.AddressID
  JOIN Towns AS t
    ON a.TownID    = t.TownID
 ORDER BY e.FirstName,
          e.LastName

----------------------------------------------------

--Task 3 Sales Employee

SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       d.Name AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
 WHERE d.Name = 'Sales'
 ORDER BY e.EmployeeID

----------------------------------------------------

--Task 4 Employee Departments

SELECT TOP 5
       e.EmployeeID,
       e.FirstName,
       e.Salary,
       d.Name AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
 WHERE e.Salary > 15000
 ORDER BY e.DepartmentID

----------------------------------------------------

--Task 5 Employees without Project

SELECT TOP 3
       e.EmployeeID,
       e.FirstName
  FROM Employees AS e
  LEFT JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
 WHERE ep.ProjectID IS NULL
 ORDER BY e.EmployeeID

----------------------------------------------------
--Task 6 Employees Hired After

SELECT e.FirstName,
       e.LastName,
       e.HireDate,
       d.Name AS DeptName
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
 WHERE e.HireDate > '01-01-1999'
   AND d.Name IN ( 'Sales', 'Finance' )
 ORDER BY e.HireDate

----------------------------------------------------

--Task 7 Employee with Project

SELECT TOP 5
       e.EmployeeID,
       e.FirstName,
       p.Name
  FROM EmployeesProjects AS ep
  JOIN Employees AS e
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID
 WHERE p.StartDate > '08-13-2002'
   AND p.EndDate IS NULL
 ORDER BY e.EmployeeID

----------------------------------------------------

--Task 8 Employee 24

SELECT e.EmployeeID,
       e.FirstName,
       CASE
            WHEN p.StartDate >= '01-01-2005' THEN NULL
            ELSE p.Name END AS ProjectName
  FROM Employees AS e
  JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID
 WHERE e.EmployeeID = 24

----------------------------------------------------

--Task 9 Employee Manager

SELECT e.EmployeeID,
       e.FirstName,
       e.ManagerID,
       m.FirstName AS ManagerName
  FROM Employees AS e
  JOIN Employees AS m
    ON m.EmployeeID = e.ManagerID
 WHERE e.ManagerID IN ( 3, 7 )
 ORDER BY e.EmployeeID

----------------------------------------------------

--Task 10 Employee Summary

SELECT TOP 50
       e.EmployeeID,
       CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
       d.Name
  FROM Employees AS e
  JOIN Employees AS m
    ON e.ManagerID    = m.EmployeeID
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 ORDER BY e.EmployeeID

----------------------------------------------------

--Task 11 Min Average Salary

SELECT TOP 1
       AVG(Salary) AS MinAverageSalary
  FROM Employees
 GROUP BY DepartmentID
 ORDER BY MinAverageSalary

----------------------------------------------------

--Task 12 Highest Picks in Bulgaria

SELECT c.CountryCode,
       m.MountainRange,
       p.PeakName,
       p.Elevation
  FROM MountainsCountries AS mc
  JOIN Countries AS c
    ON mc.CountryCode = c.CountryCode
  JOIN Mountains AS m
    ON mc.MountainId  = m.Id
  JOIN Peaks AS p
    ON m.Id           = p.MountainId
 WHERE c.CountryName = 'Bulgaria'
   AND p.Elevation   > 2835
 ORDER BY p.Elevation DESC

----------------------------------------------------

--Task 13 Count Mountain Ranges

SELECT CountryCode,
       COUNT(MountainId) AS MountainRanges
  FROM MountainsCountries
 WHERE CountryCode IN (   SELECT CountryCode
                            FROM Countries
                           WHERE CountryName IN ( 'United States', 'Bulgaria', 'Russia' ))
 GROUP BY CountryCode

----------------------------------------------------

--Task 14 Countries with Rivers

SELECT TOP 5
       c.CountryName,
       r.RiverName
  FROM Countries AS c
  LEFT JOIN CountriesRivers AS cr
    ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers AS r
    ON cr.RiverId    = r.Id
 WHERE c.ContinentCode = 'AF'
 ORDER BY c.CountryName

----------------------------------------------------

--Task 15 Continents and Currencies


SELECT ContinentCode,
       CurrencyCode,
       CurrencyUsage
  FROM (   SELECT *,
                  DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) AS CurrencyRank
             FROM (   SELECT ContinentCode,
                             CurrencyCode,
                             COUNT(*) AS CurrencyUsage
                        FROM Countries
                       GROUP BY ContinentCode,
                                CurrencyCode
                      HAVING COUNT(*) > 1) AS CurrencyUsageSubquery ) As CurrenctRanking
 WHERE CurrencyRank = 1

----------------------------------------------------

--Task 16 Country without any Mountains

SELECT COUNT(*) AS [Count]
  FROM Countries AS c
  LEFT JOIN MountainsCountries AS mc
    ON c.CountryCode = mc.CountryCode
 WHERE mc.MountainId IS NULL

----------------------------------------------------

--Task 17 Highest Peak and Longest River by Country
SELECT TOP 5
       c.CountryName,
       MAX(p.Elevation) AS HighestPeakEvaluation,
       MAX(r.Length) AS LongestRiverLength
  FROM Countries AS c
  LEFT JOIN CountriesRivers AS cr
    ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers AS r
    ON cr.RiverId    = r.Id
  LEFT JOIN MountainsCountries AS mc
    ON c.CountryCode = mc.CountryCode
  LEFT JOIN Peaks AS p
    ON mc.MountainId = p.MountainId
 GROUP BY c.CountryName
 ORDER BY HighestPeakEvaluation DESC,
          LongestRiverLength DESC,
          c.CountryName
----------------------------------------------------

--Task 18 Highest Peak Name and Elevation by Country

SELECT
       TOP 5
       CountryName AS Country,
       ISNULL(PeakName, 'no highest peak') AS [Highest Peak Name],
       ISNULL(Elevation, 0) AS [Highest Peak Elevation],
       ISNULL(MountainRange, 'no mountain') AS Mountain
  FROM (   SELECT c.CountryName,
                  p.PeakName,
                  p.Elevation,
                  m.MountainRange,
                  DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS RN
             FROM Countries c
             LEFT JOIN MountainsCountries mc
               ON mc.CountryCode = c.CountryCode
             LEFT JOIN Mountains m
               ON m.Id           = mc.MountainId
             LEFT JOIN Peaks p
               ON p.MountainId   = m.Id) AS SubQ
 WHERE SubQ.RN = 1
 ORDER BY Country,
          [Highest Peak Name]
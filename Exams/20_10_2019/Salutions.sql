--Task 1 DDL

CREATE DATABASE Service

GO

USE Service

GO

CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Username NVARCHAR(30) UNIQUE NOT NULL,
Password NVARCHAR(50) NOT NULL,
[Name] NVARCHAR(50),
Birthdate DATETIME2,
Age INT CHECK(Age >= 14 AND Age <= 110),
Email NVARCHAR(50) NOT NULL
)

GO

CREATE TABLE Departments
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

GO

CREATE TABLE Employees
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(25),
LastName NVARCHAR(25),
Birthdate DATETIME2,
Age INT CHECK(Age >= 18 AND Age <= 110),
DepartmentId INT REFERENCES Departments(Id)
)

GO

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL,
DepartmentId INT REFERENCES Departments(Id) NOT NULL
)

GO

CREATE TABLE Status
(
Id INT PRIMARY KEY IDENTITY,
[Label] NVARCHAR(30) NOT NULL
)

GO

CREATE TABLE Reports
(
Id INT PRIMARY KEY IDENTITY,
CategoryId INT REFERENCES Categories(Id) NOT NULL,
StatusId INT REFERENCES Status(Id) NOT NULL,
OpenDate DATETIME2 NOT NULL,
CloseDate DATETIME2,
[Description] NVARCHAR(200) NOT NULL,
UserId INT REFERENCES Users(Id) NOT NULL,
EmployeeId INT REFERENCES Employees(Id)
)

-----------------------------------------------

--Task 2 Insert

INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
	VALUES
('Marlo','O''Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26',	4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate,Description, UserId, EmployeeId)
		VALUES

(1,	1, '2017-04-13', NULL,	'Stuck Road on Str.133', 6,	2),
(6,	3, '2015-09-05', '2015-12-06', 'Charity trail running',	3, 5),
(14, 2,	'2015-09-07', NULL,	'Falling bricks on Str.58', 5, 2),
(4,	3,	'2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1,	1)

-----------------------------------------------

--Task 3 Update

UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

-----------------------------------------------

--Task 4 Delete

DELETE FROM Reports
WHERE StatusId = 4

-----------------------------------------------

--Task 5 Unassigned Reports

SELECT
	Description,
	FORMAT(OpenDate, 'dd-MM-yyyy') AS OpenDate
	FROM Reports
	WHERE EmployeeId IS NULL
	ORDER BY Reports.OpenDate,
	Description

-----------------------------------------------

--Task 6 Reports & Categories

SELECT
	r.Description,
	c.Name AS CategoryName
	FROM Reports AS r
	JOIN Categories AS c ON r.CategoryId = c.Id
	ORDER BY Description,
		CategoryName

-----------------------------------------------

--Task 7 Most Reported Category

SELECT TOP 5
	c.Name AS CategoryName,
	Count(*) ReportsNumber
	FROM Reports AS r
	JOIN Categories AS c ON r.CategoryId = c.Id
	GROUP BY c.Name
	ORDER BY ReportsNumber DESC,
		CategoryName

-----------------------------------------------

--Task 8 Birthday Report

SELECT
	u.Username,
	c.Name AS CategoryName
	FROM Reports AS r
	JOIN Categories AS c ON r.CategoryId = c.Id
	JOIN Users AS u ON r.UserId = u.Id
	--WHERE DATEPART(DAY, u.Birthdate) = DATEPART(DAY, r.OpenDate) AND
		--DATEPART(MONTH, u.Birthdate) = DATEPART(MONTH, r.OpenDate)
	WHERE FORMAT(u.Birthdate, 'MM-dd') = FORMAT(r.OpenDate, 'MM-dd')
	ORDER BY u.Username,
	CategoryName

-----------------------------------------------

--Task 9 Users per Employee

SELECT
	CONCAT_WS(' ', e.FirstName, e.LastName) AS FullName,
	COUNT(UserId) AS UsersCount
	FROM Reports AS r
	JOIN Employees AS e ON r.EmployeeId = e.Id
	GROUP BY e.FirstName, e.LastName
	ORDER BY UsersCount DESC,
	FullName

-----------------------------------------------

--Task 10 Full Info

SELECT
	ISNULL(e.FirstName + ' ' + e.LastName,'None') AS Employee,
	ISNULL(d.Name, 'None') AS Department,
	ISNULL(c.Name, 'None') AS Category,
	r.Description,
	FORMAT(OpenDate, 'dd.MM.yyyy') AS OpenDate,
	s.Label AS Status ,
	ISNULL(u.Name, 'None') AS [User]
	FROM Reports AS r
	LEFT JOIN Employees AS e ON r.EmployeeId = e.Id
	LEFT JOIN Categories AS c ON r.CategoryId = c.Id
	LEFT JOIN Departments AS d ON e.DepartmentId = d.Id
	LEFT JOIN [Status] AS s ON r.StatusId = s.Id
	LEFT JOIN Users AS u ON r.UserId = u.Id
	ORDER BY e.FirstName DESC,
	e.LastName DESC,
	d.Name ,
	c.Name,
	Description,
	r.OpenDate,
	s.Label,
	u.Name

-----------------------------------------------

--Task 11 Hours to Complete

GO

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN

		IF @StartDate = 0 OR @EndDate = 0
		RETURN 0
		DECLARE @hc INT =
		DATEDIFF(HOUR,@StartDate, @EndDate)
		RETURN @hc
END
GO

SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
   FROM Reports

-----------------------------------------------

--Task 12 Assign Employee
GO
CREATE PROCEDURE name usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN
	DECLARE @EmpD INT =
	(SELECT DepartmentId FROM Employees WHERE Id = @EmployeeId)

	DECLARE @ReportD INT =
	(SELECT c.DepartmentId FROM Reports AS r JOIN Categories AS c ON r.CategoryId = c.Id WHERE Id = @ReportD)

	IF @EmpD != @ReportD
	THROW 50000 ,'Employee doesn''t belong to the appropriate department!', 1

	IF @EmpD = @ReportD
	UPDATE Reports
	SET EmployeeId = @EmployeeId
	WHERE Id = @RReportId
END
GO

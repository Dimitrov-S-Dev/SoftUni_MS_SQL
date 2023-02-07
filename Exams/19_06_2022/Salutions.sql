--Task 1 DDL

CREATE DATABASE Zoo

GO

USE Zoo

CREATE TABLE Owners
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
Address VARCHAR(50)
)

CREATE TABLE AnimalTypes
(
Id INT PRIMARY KEY IDENTITY,
AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages
(
Id INT PRIMARY KEY IDENTITY,
AnimalTypeId INT REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL,
BirthDate DATE NOT NULL,
OwnerId INT REFERENCES Owners(Id),
AnimalTypeId INT REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE AnimalsCages
(
CageId INT REFERENCES Cages(Id) NOT NULL,
AnimalId INT REFERENCES Animals(Id) NOT NULL
PRIMARY KEY(CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments
(
Id INT PRIMARY KEY IDENTITY,
DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
Address VARCHAR(50),
AnimalId INT REFERENCES Animals(Id),
DepartmentId INT REFERENCES VolunteersDepartments(Id) NOT NULL
)

----------------------------------------------------

--Task 2 Insert

INSERT INTO Volunteers(Name, PhoneNumber,Address,AnimalId,DepartmentId) VALUES
('Anita Kostova'  ,	'0896365412',  'Sofia, 5 Rosa str.'     ,       15, 1),
('Dimitur Stoev'  ,	'0877564223',	NULL                    ,	    42,  4),
('Kalina Evtimova',	'0896321112',	'Silistra 21 Breza str.',	     9,	7),
('Stoyan Tomov'   ,	'0898564100',	'Montana, 1 Bor str.'   ,	    18,	8),
('Boryana Mileva' ,	'0888112233',	 NULL                   ,	    31,	5)

INSERT INTO Animals(Name, BirthDate, OwnerId, AnimalTypeId) VALUES
('Giraffe'         , '2018-09-21',  21, 1),
('Harpy Eagle'     , '2015-04-17',  15, 3),
('Hamadryas Baboon', '2017-11-02',	NULL, 1),
('Tuatara'         , '2021-06-30',   2, 4)

----------------------------------------------------

--Task 3 Update

UPDATE Animals
SET OwnerId = 4
WHERE OwnerId IS NULL

----------------------------------------------------

--Task 4 Delete

DELETE FROM Volunteers
WHERE DepartmentId = 2

DELETE FROM VolunteersDepartments
WHERE Id = 2

----------------------------------------------------

--Task 5 Volunteers

SELECT
	Name,
	PhoneNumber,
	Address,
	AnimalId,
	DepartmentId
	FROM Volunteers
	ORDER BY Name,
	AnimalId,
	DepartmentId

-----------------------------------------------

--Task 6 Animals data

SELECT
	a.Name,
	at.AnimalType,
	FORMAT(a.BirthDate, 'dd.MM.yyyy')
	FROM Animals AS a
	JOIN AnimalTypes AS at ON a.AnimalTypeId = at.Id
	ORDER BY a.Name

-----------------------------------------------

--Task 7 Owners and Their Animals

SELECT TOP 5
	o.Name,
	COUNT(*) AS CountOfAimals
	FROM Animals AS a
	JOIN Owners AS o ON a.OwnerId = o.Id
	GROUP BY o.Name
	ORDER BY CountOfAimals DESC,
	o.Name

-----------------------------------------------

--Task 8 Owners,Animals and Cages

SELECT
	CONCAT(o.Name, '-', a.Name) AS OwnersAnimals,
	o.PhoneNumber,
	c.Id AS CageId
	FROM Owners AS o
	JOIN Animals AS a ON a.OwnerId = o.Id
	JOIN AnimalTypes AS at ON a.AnimalTypeId = at.Id
	JOIN AnimalsCages AS ac ON a.Id = ac.AnimalId
	JOIN Cages AS c ON ac.CageId= c.Id
	WHERE at.AnimalType = 'mammals'
	ORDER BY o.Name,
	a.Name DESC

-----------------------------------------------

--Task 9 Volunteers in Sofia

SELECT
	v.Name,
	v.PhoneNumber,
	SUBSTRING(Address, CHARINDEX(',', Address) + 2, LEN(v.Address)) AS Address
	FROM Volunteers AS v
	JOIN VolunteersDepartments AS vd ON v.DepartmentId = vd.Id
	WHERE vd.DepartmentName = 'Education program assistant'
	AND v.Address LIKE ('%Sofia%')
	ORDER BY v.Name

-----------------------------------------------

--Task 10 Animals for Adoption

SELECT
	a.Name,
	YEAR(a.BirthDate) AS BirthYear,
	at.AnimalType
	FROM Animals AS a
	JOIN AnimalTypes AS at ON a.AnimalTypeId = at.Id
	WHERE OwnerId IS NULL
		AND at.Id !=3
		AND DATEDIFF(YEAR, a.BirthDate, '2022-01-01') < 5
	ORDER BY a.Name

-----------------------------------------------

--Task 11 All Volunteers an a Department

GO
CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(50))
RETURNS INT
AS
BEGIN
		DECLARE @getMe INT =
		(SELECT COUNT(*)
		FROM Volunteers AS v
		JOIN VolunteersDepartments AS vd ON v.DepartmentId = vd.Id
		WHERE vd.DepartmentName = 'Guest engagement')
		RETURN @getMe

END

-----------------------------------------------

--Task 12 Animals with Owner or Not

CREATE PROCEDURE usp_AnimalsWithOwnersOrNot(@AnimalName VARCAHR(50))
AS
BEGIN
	IF (SELECT OwnerId FROM Animals
		WHERE Name = @AnimalName) IS NULL
		BEGIN
		SELECT Name,
			'For adoption' AS OwnerName
			FROM Animals
			WHERE Name =@AnimalName
		END
	ELSE
	BEGIN
		SELECT a.Name,
				o.Name AS OwnerName
			FROM Animals AS a
			JOIN Owners AS o ON o.Id =a.OwnerId
			WHERE a.Name = @AnimalName
	END
END


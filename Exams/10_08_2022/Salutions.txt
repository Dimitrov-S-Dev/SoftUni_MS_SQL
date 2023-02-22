--Task 1 DDL
CREATE DATABASE NationalTouristSitesOfBulgaria
GO

USE NationalTouristSitesOfBulgaria

GO

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

GO

CREATE TABLE Locations
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
Municipality VARCHAR(50),
Province VARCHAR(50)
)

GO

CREATE TABLE Sites
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
LocationId INT REFERENCES Locations(Id) NOT NULL,
CategoryId INT REFERENCES Categories(Id) NOT NULL,
Establishment VARCHAR(15)
)

GO

CREATE TABLE Tourists
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
Age INT CHECK(Age >= 0 AND Age <= 120) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Nationality VARCHAR(30) NOT NULL,
Reward VARCHAR(20)
)

GO

CREATE TABLE SitesTourists
(
TouristId INT REFERENCES Tourists(Id),
SiteId INT REFERENCES Sites(Id),
PRIMARY KEY(TouristId, SiteId)
)

GO

CREATE TABLE BonusPrizes
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

GO

CREATE TABLE TouristsBonusPrizes
(
TouristId INT REFERENCES Tourists(Id),
BonusPrizeId INT REFERENCES BonusPrizes(Id),
PRIMARY KEY(TouristId, BonusPrizeId)
)

----------------------------------------------------

--Task 2 Insert

INSERT INTO Tourists([Name], Age, PhoneNumber, Nationality, Reward)
	VALUES
('Borislava Kazakova',	52,	'+359896354244',	'Bulgaria',	NULL),
('Peter Bosh',	48,	'+447911844141',	'UK',	NULL),
('Martin Smith',	29,	'+353863818592',	'Ireland',	'Bronze badge'),
('Svilen Dobrev',	49,	'+359986584786',	'Bulgaria',	'Silver badge'),
('Kremena Popova',	38,	'+359893298604',	'Bulgaria',	NULL)


INSERT INTO Sites([Name], LocationId,CategoryId,Establishment)
	VALUES
('Ustra fortress',	90,	7,	'X'),
('Karlanovo Pyramids',	65,	7,	NULL),
('The Tomb of Tsar Sevt', 63,	8,	'V BC'),
('Sinite Kamani Natural Park',	17,	1,	NULL),
('St. Petka of Bulgaria – Rupite',	92,	6,	'1994')


----------------------------------------------------

--Task 3 Update

UPDATE Sites
SET Establishment = 'not defined'
WHERE Establishment IS NULL

----------------------------------------------------

--Task 4 Delete

DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId = 5

DELETE FROM BonusPrizes
WHERE Name = 'Sleeping bag'

----------------------------------------------------

--Task 5 Tourists

SELECT
	Name,
	Age,
	PhoneNumber,
	Nationality
	FROM Tourists
	ORDER BY Nationality,
	Age DESC,
	Name

-----------------------------------------------

--Task 6 Sites with Their Location and Category

SELECT
	s.Name AS Site,
	l.Name AS Location,
	s.Establishment,
	c.Name AS Category
	FROM Sites AS s
	JOIN Locations AS l ON s.LocationId = l.Id
	JOIN Categories AS c ON s.CategoryId = c.Id
	GROUP BY c.Name,s.Name,l.Name,s.Establishment
	ORDER BY Category DESC,
	Location,
	Site

-----------------------------------------------

--7 Count the Sites in Sofia Province

SELECT
	l.Province,
	l.Municipality,
	l.Name AS [Loctation],
	COUNT(*) AS CountOfSites
	FROM Sites AS s
	JOIN Locations AS l ON s.LocationId = l.Id
	WHERE l.Province = 'Sofia'
	GROUP BY l.Province,l.Municipality,l.Name
	ORDER BY CountOfSites DESC,
	l.Name

-----------------------------------------------

--Task 8 Tourist Sites established BC


SELECT
	s.Name,
	l.Name AS Location,
	l.Municipality,
	l.Province,
	s.Establishment
	FROM Sites AS s
	JOIN Locations AS l ON s.LocationId = l.Id
	WHERE ((l.Name NOT LIKE 'B%')
	AND (l.Name NOT LIKE 'M%') AND (l.Name NOT LIKE 'D%')) AND
	s.Establishment LIKE '%BC'
	ORDER BY s.Name

-----------------------------------------------

--Task 9 Tourists with their Bonus Prizes

SELECT
	t.Name,
	t.Age,
	t.PhoneNumber,
	t.Nationality,
	CASE
		WHEN tbp.BonusPrizeId IS NULL THEN '(no bonus prize)'
		ELSE bp.Name
	END
	FROM Tourists AS t
	LEFT JOIN TouristsBonusPrizes AS tbp ON tbp.TouristId = t.Id
	left JOIN BonusPrizes AS bp ON tbp.BonusPrizeId = bp.Id
	ORDER BY t.Name

-----------------------------------------------

--Task 10 Tourists visiting History and Archeology sites

SELECT
	RIGHT(t.Name, CHARINDEX(' ', REVERSE(t.Name)) - 1) AS LastName,
	t.Nationality,
	t.Age,
	t.PhoneNumber
	FROM SitesTourists AS st
	JOIN Sites AS s ON st.SiteId = s.Id
	JOIN Tourists AS t ON st.TouristId = t.Id
	JOIN Categories as c ON s.CategoryId = c.Id
	WHERE c.Id = 8
	GROUP BY t.Name,t.Nationality,t.Age,t.PhoneNumber
	ORDER BY LastName

SELECT * FROM Categories

-----------------------------------------------

--Task 11 Tourists Count on a Tourist Site
GO

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(50))
RETURNS INT
AS
BEGIN
		RETURN
		(SELECT COUNT(*)
		FROM SitesTourists AS st
		JOIN Sites AS s ON st.SiteId = s.Id
		JOIN Tourists AS t ON st.TouristId = t.Id
		WHERE s.Name = 'Regional History Museum – Vratsa')

END

-----------------------------------------------

--Task 12 Annual Reward Lottery
GO
CREATE PROCEDURE usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN
		IF (SELECT COUNT(*) FROM SitesTourists AS st
			JOIN Tourists AS t ON st.TouristId = t.Id
			WHERE t.Name = @TouristName) >= 100

			BEGIN
				UPDATE Tourists
				SET Reward = 'Gold badge'
				WHERE Name = @TouristName
			END

		ELSE IF (SELECT COUNT(*) FROM SitesTourists AS st
			JOIN Tourists AS t ON st.TouristId = t.Id
			WHERE t.Name = @TouristName) >= 50

			BEGIN
				UPDATE Tourists
				SET Reward = 'Silver badge'
			END

		ELSE IF (SELECT COUNT(*) FROM SitesTourists AS st
			JOIN Tourists AS t ON st.TouristId = t.Id
			WHERE t.Name = @TouristName) >= 25

			BEGIN
				UPDATE Tourists
				SET Reward = 'Bronze badge'
			END
END

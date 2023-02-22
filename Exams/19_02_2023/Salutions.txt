--Task 1 DDL

CREATE DATABASE Boardgames
GO

USE Boardgames

GO

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

GO

CREATE TABLE Addresses
(
Id INT PRIMARY KEY IDENTITY,
StreetName NVARCHAR(100) NOT NULL,
StreetNumber INT NOT NULL,
Town VARCHAR(30) NOT NULL,
Country VARCHAR(50) NOT NULL,
ZIP INT NOT NULL
)

GO

CREATE TABLE Publishers
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) UNIQUE NOT NULL,
AddressId INT REFERENCES Addresses(Id) NOT NULL,
Website NVARCHAR(40),
Phone NVARCHAR(20)
)

GO

CREATE TABLE PlayersRanges
(
Id INT PRIMARY KEY IDENTITY,
PlayersMin INT NOT NULL,
PlayersMax INT NOT NULL
)

GO

CREATE TABLE Boardgames
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
YearPublished INT NOT NULL,
Rating DECIMAL(18,2) NOT NULL,
CategoryId INT REFERENCES Categories(Id) NOT NULL,
PublisherId INT REFERENCES Publishers(Id) NOT NULL,
PlayersRangeId INT REFERENCES PlayersRanges(Id) NOT NULL
)

GO

CREATE TABLE Creators
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(30) NOT NULL,
Email NVARCHAR(30) NOT NULL
)

GO

CREATE TABLE CreatorsBoardgames
(
CreatorId INT REFERENCES Creators(Id),
BoardgameId INT REFERENCES Boardgames(Id),
PRIMARY KEY(CreatorId, BoardgameId)
)


--Task 2 INSERT

INSERT INTO Boardgames([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
	VALUES
('Deep Blue',	2019,	5.67,	1,	15,	7),
('Paris',	2016,	9.78,	7,	1,	5),
('Catan: Starfarers',	2021,	9.87,	7,	13,	6),
('Bleeding Kansas',	2020,	3.25,	3,	7,	4),
('One Small Step',	2019,	5.75,	5,	9,	2)


INSERT INTO Publishers([Name], AddressId, Website, Phone)
	VALUES
('Agman Games',	5,	'www.agmangames.com',	'+16546135542'),
('Amethyst Games',	7,	'www.amethystgames.com',	'+15558889992'),
('BattleBooks',	13,	'www.battlebooks.com',	'+12345678907')

--Task 3 UPDATE

UPDATE PlayersRanges
SET PlayersMax += 1
WHERE PlayersMin = 2 AND PlayersMax = 2

UPDATE Boardgames
SET [Name] += 'V2'
WHERE YearPublished >= 2020


--Task 4 DELETE

DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN(1, 16, 31)

DELETE FROM Boardgames
WHERE PublisherId = 1

DELETE  FROM Publishers
WHERE AddressId = 5

DELETE FROM Addresses
WHERE Town LIKE 'L%'


--Task 5 Boardgames by Year of Publication


SELECT
	[Name],
	Rating
	FROM Boardgames
	ORDER BY YearPublished,
	Name DESC


--Task 6 Boardgames by Category

SELECT
	b.Id,
	b.Name,
	b.YearPublished,
	c.Name
	FROM Boardgames AS b
	JOIN Categories AS c ON b.CategoryId = c.Id
	WHERE c.Name IN('Strategy Games', 'Wargames' )
	ORDER BY b.YearPublished DESC


--Task 7 Creators without Boardgames

SELECT
	c.Id,
	CONCAT_WS(' ', c.FirstName, c.LastName) AS CreatorName,
	c.Email
	FROM Creators AS c
	LEFT JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
	WHERE BoardgameId IS NULL


--Task 8  First 5 Boardgames

SELECT TOP 5
	b.Name,
	b.Rating,
	c.Name
	FROM Boardgames AS b
	LEFT JOIN Categories AS c ON b.CategoryId = c.Id
	LEFT JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
	WHERE (b.Rating > 7.00 AND b.Name LIKE '%a%') OR (b.Rating > 7.50 AND (pr.PlayersMin = 2 AND pr.PlayersMax = 5))
	ORDER BY b.Name,
	b.Rating DESC


--Task 9 Creators with Emails

SELECT
	c.FirstName + ' ' + c.LastName AS FullName,
	c.Email,
	MAX(b.Rating) AS Rating
	FROM Creators AS c
	JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
	JOIN Boardgames AS b ON cb.BoardgameId = b.Id
	WHERE c.Email LIKE '%.com'
	GROUP BY c.FirstName, c.LastName, c.Email
	ORDER BY FullName


--Task 10 Creators by Rating


SELECT
	c.LastName,
	CEILING(AVG(b.Rating)) AS AverageRating,
	p.Name
	FROM Creators AS c
	LEFT JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
	LEFT JOIN Boardgames AS b ON cb.BoardgameId = b.Id
	LEFT JOIN Publishers AS p ON b.PublisherId = p.Id
	WHERE p.Name = 'Stonemaier Games'
	GROUP BY b.Rating,LastName,p.Name
	ORDER BY AverageRating DESC,
	b.Rating DESC


--Task 11 Creator with Boardgames

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
		RETURN
		(
		SELECT
			COUNT(cb.BoardgameId)
			FROM Creators AS c
			JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
			WHERE c.FirstName = @name
		)

END



--Task 12 Search for Boardgame with Specific Category

CREATE PROCEDURE usp_SearchByCategory @category VARCHAR(50)
AS
BEGIN
		SELECT
			b.Name AS [Name],
			b.YearPublished,
			b.Rating,
			c.Name AS CategoryName,
			p.Name AS PublisherName,
			CONVERT(VARCHAR,pr.PlayersMin) + ' people' AS MinPlayers,
			CONVERT(VARCHAR,pr.PlayersMax) + ' people' AS MaxPlayers
			FROM Boardgames AS b
			JOIN Categories AS c ON b.CategoryId = c.Id
			JOIN PlayersRanges AS pr ON b.PlayersRangeId = pr.Id
			JOIN Publishers AS p ON b.PublisherId = p.Id
			WHERE c.Name = @category
			ORDER BY p.Name,
			b.YearPublished DESC

END

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


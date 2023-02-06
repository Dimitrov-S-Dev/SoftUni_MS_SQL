--Task 1 DDL Database Design

CREATE DATABASE TripService

USE TripService

CREATE TABLE Cities
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
CountryCode CHAR(2) NOT NULL
)


CREATE TABLE Hotels

(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
CityId INT REFERENCES Cities(Id) NOT NULL,
EmployeeCount INT NOT NULL,
BaseRate DECIMAL(18,2)
)

CREATE TABLE Rooms
(
Id INT PRIMARY KEY IDENTITY,
Price DECIMAL (18,2) NOT NULL,
[Type] NVARCHAR(20) NOT NULL,
Beds INT NOT NULL,
HotelId INT REFERENCES Hotels(Id) NOT NULL
)

CREATE TABLE Trips
(
Id INT PRIMARY KEY IDENTITY,
RoomId INT REFERENCES Rooms (ID) NOT NULL,
BookDate DATE NOT NULL,
ArrivalDate DATE NOT NULL,
ReturnDate DATE NOT NULL,
CancelDate DATE,
CHECK(BookDate < ArrivalDate ),
CHECK(ReturnDate > ArrivalDate)
)


CREATE TABLE Accounts
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(20),
LastName NVARCHAR(50) NOT NULL,
CityId INT REFERENCES Cities(Id) NOT NULL,
BirthDate DATE NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE
)


CREATE TABLE AccountsTrips
(
AccountId INT REFERENCES Accounts(Id),
TripId INT REFERENCES Trips(Id),
Luggage INT NOT NULL,
PRIMARY KEY(AccountId, TripId),
CHECK(Luggage >= 0)
)

----------------------------------------------------

--Task 2 Insert

INSERT INTO Accounts(FirstName, MiddleName, LastName, CityId, BirthDate, Email)
	VALUES
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59, '1894-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')


INSERT INTO Trips(RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
	VALUES
(101, '2015-04-12', '2015-04-14', '2015-04-20', '2015-02-02'),
(102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
(103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
(104, '2012-03-17', '2012-03-31', '2012-04-01', '2012-01-10'),
(109, '2017-08-07', '2017-08-28', '2017-08-29', NULL)

----------------------------------------------------

--Task 3 Update

UPDATE Rooms
	SET Price *= 1.14
	WHERE HotelId IN(5, 7, 9)

----------------------------------------------------

--Task 4 Delete

DELETE
	FROM AccountsTrips
	WHERE AccountId = 47

----------------------------------------------------

--Task 5 EEE-Email

SELECT
	a.FirstName,
	a.LastName,
	FORMAT(a.BirthDate, 'MM-dd-yyyy') AS BirthDate,
	c.Name AS Hometown,
	a.Email
	FROM Accounts AS a
	JOIN Cities AS c ON a.CityId = c.Id
	WHERE a.Email LIKE 'e%'
	ORDER BY c.Name

----------------------------------------------------

--Task 6 City Statistics

SELECT
	c.Name AS City,
	COUNT(*) AS Hotels
	FROM Cities AS c
	JOIN Hotels AS h ON c.Id = h.CityId
	GROUP BY c.Name
	ORDER BY Hotels DESC,
		City

----------------------------------------------------

--Task 7 Longest and Shortest Trips

SELECT
	a.Id AS AccountId,
	FirstName + ' ' + LastName AS FullName,
	MAX(DATEDIFF(DAY, ArrivalDate, ReturnDate)) AS LongestTrip,
	MIN(DATEDIFF(DAY, ArrivalDate, ReturnDate)) AS ShortestTrip
	FROM AccountsTrips AS at
	JOIN Accounts AS a ON at.AccountId = a.Id
	JOIN Trips AS t ON at.TripId = t.Id
	WHERE CancelDate IS NULL AND MiddleName IS NULL
	GROUP BY a.Id, FirstName,LastName
	ORDER BY LongestTrip DESC,
				ShortestTrip ASC

----------------------------------------------------

--Task 8 Metropolis

SELECT
	TOP 10
	c.Id,
	C.Name AS City,
	c.CountryCode,
	COUNT(*) AS Accounts
	FROM Cities AS c
	JOIN Accounts AS a ON c.Id = a.CityId
	GROUP BY c.Id, c.Name, c.CountryCode
	ORDER BY Accounts DESC

----------------------------------------------------

--Task 9 Romantic Getaways

SELECT
	a.Id,
	a.Email,
	c.Name AS City,
	COUNT(*) AS Trips
	FROM AccountsTrips AS at
	JOIN Accounts AS a ON at.AccountId = a.Id
	JOIN Cities AS c ON a.CityId = c.Id
	JOIN Trips AS t ON at.TripId = t.Id
	JOIN Rooms as r ON t.RoomId = r.Id
	JOIN Hotels AS h ON r.HotelId = h.Id
	WHERE a.CityId = h.CityId
	GROUP BY a.Id, a.Email, c.Name
	ORDER BY Trips DESC,
	a.Id

----------------------------------------------------

--Task 10 GDPR Violation

SELECT
	at.TripId,
	CONCAT_WS(' ', a.FirstName, a.MiddleName, a.LastName) AS [Full Name],
	c.Name AS [From],
	hc.Name AS [To],
	CASE
		WHEN CancelDate IS NULL THEN CONVERT(NVARCHAR(MAX), DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate)) + ' days'
		ELSE 'Canceled'
		END
		AS Duration
	FROM AccountsTrips AS at
	JOIN Accounts AS a ON at.AccountId = a.Id
	JOIN Cities AS c ON a.CityId = c.Id
	JOIN Trips AS t ON at.TripId = t.Id
	JOIN Rooms AS r ON t.RoomId = r.Id
	Join Hotels AS h ON r.HotelId = h.Id
	JOIN Cities AS hc ON h.CityId = hc.Id
	ORDER BY [Full Name],
	at.TripId

----------------------------------------------------

--Task 12 Switch Room

CREATE OR ALTER PROCEDURE usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS

BEGIN
	DECLARE @TripHotelId INT = (
	SELECT r.HotelId FROM Trips AS t JOIN Rooms AS r ON t.RoomId = r.Id WHERE t.Id = @TripId)

	DECLARE @TargetRoomHotelId INT = (
	SELECT HotelId FROM Rooms WHERE Id = @TargetRoomId)

	IF @TripHotelId != @TargetRoomHotelId
		THROW 50001, 'Target room is in another hotel!', 1

	DECLARE @TripAccounts INT = (
	SELECT COUNT(*) FROM AccountsTrips WHERE TripId = @TripId)

	DECLARE @TargetRoomBeds INT = (
	SELECT Beds FROM Rooms WHERE Id = @TargetRoomId)

	IF @TripAccounts > @TargetRoomBeds
		THROW 50002, 'Not enough beds in target room!', 1
	UPDATE Trips
	SET RoomId = @TargetRoomId WHERE Id = @TripId
END


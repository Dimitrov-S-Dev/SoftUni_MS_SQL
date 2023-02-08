--Task 1 DDL

CREATE DATABASE Airport

GO

USE Airport

CREATE TABLE Passengers
(
Id INT PRIMARY KEY IDENTITY,
FullName VARCHAR(100) UNIQUE NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots
(
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(30) UNIQUE NOT NULL,
LastName VARCHAR(30) UNIQUE NOT NULL,
Age TINYINT CHECK(Age >= 21 AND Age <= 62) NOT NULL,
Rating FLOAT CHECK(Rating BETWEEN 0.0 AND 10.0)
)

CREATE TABLE AircraftTypes
(
Id INT PRIMARY KEY IDENTITY,
TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft
(
Id INT PRIMARY KEY IDENTITY,
Manufacturer VARCHAR(25) NOT NULL,
Model VARCHAR(30) NOT NULL,
[Year] INT NOT NULL,
FlightHours INT,
Condition CHAR(1) NOT NULL,
TypeId INT REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
AircraftId INT REFERENCES Aircraft(Id),
PilotId INT REFERENCES Pilots(Id),
PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports
(
Id INT PRIMARY KEY IDENTITY,
AirportName VARCHAR(70) UNIQUE NOT NULL,
Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations
(
Id INT PRIMARY KEY IDENTITY,
AirportId INT REFERENCES Airports(Id) NOT NULL,
Start DATETIME NOT NULL,
AircraftId INT REFERENCES Aircraft(Id) NOT NULL,
PassengerId INT REFERENCES Passengers(Id) NOT NULL,
TicketPrice DECIMAL(18, 2) DEFAULT(15) NOT NULL
)

----------------------------------------------------

--Task 2 Insert

INSERT INTO Passengers(FullName,Email)
SELECT
	CONCAT_WS(' ', FirstName, LastName),
	CONCAT(FirstName,LastName,'@gmail.com')
	FROM Pilots
	WHERE Id >= 5 AND Id <= 15

-----------------------------------------------

--Task 3 Update

UPDATE Aircraft
SET Condition = 'A'
WHERE Condition IN('C','B') AND (FlightHours IS NULL OR FlightHours <= 100) AND
																[Year] >= 2013
-----------------------------------------------

--Task 4 Delete

DELETE FROM Passengers
WHERE LEN(FullName) <= 10

-----------------------------------------------

--Task 5 Aircraft

SELECT
	Manufacturer,
	Model,
	FlightHours,
	Condition
	FROM Aircraft
	ORDER BY FlightHours DESC

-----------------------------------------------

--Task 6 Pilots and Aircraft

SELECT
	p.FirstName,
	p.LastName,
	a.Manufacturer,
	a.Model,
	a.FlightHours
	FROM PilotsAircraft AS pa
	JOIN Pilots AS p ON pa.PilotId = p.Id
	JOIN Aircraft AS a ON pa.AircraftId = a.Id
	WHERE a.FlightHours <= 304
	ORDER BY a.FlightHours DESC,
	p.FirstName

-----------------------------------------------

--Task 7 Top 20 Flight Destinations

SELECT TOP 20
	fd.Id,
	fd.Start,
	p.FullName,
	a.AirportName,
	fd.TicketPrice
	FROM FlightDestinations AS fd
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Airports AS a ON fd.AirportId = a.Id
	WHERE DATEPART(DAY, fd.Start) % 2 = 0
	ORDER BY fd.TicketPrice DESC,
	a.AirportName

-----------------------------------------------

--Task 8 Number of Flights for Each Aircraft

SELECT
	fd.AircraftId,
	a.Manufacturer,
	a.FlightHours,
	COUNT(*) AS FlightDestinationsCount,
	ROUND(AVG(fd.TicketPrice),2)  AS AvgPrice
	FROM FlightDestinations AS fd
	JOIN Aircraft AS a ON fd.AircraftId = a.Id
	GROUP BY fd.AircraftId,a.FlightHours,a.Manufacturer
	HAVING COUNT(*) >= 2
	ORDER BY FlightDestinationsCount DESC,
		fd.AircraftId

-----------------------------------------------

--Task 9 Regular Passengers

SELECT
	p.FullName,
	COUNT(a.Id) AS CountOfAircraft,
	SUM(fd.TicketPrice) AS TotalPayed
	FROM FlightDestinations AS fd
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Aircraft AS a ON  fd.AircraftId = a.Id
	WHERE FullName LIKE('_a%')
	GROUP BY p.FullName
	HAVING COUNT(a.Id) > 1
	ORDER BY p.FullName

-----------------------------------------------

--Task 10 Full info for Flight Destinations

SELECT
	a.AirportName,
	fd.Start,
	fd.TicketPrice,
	p.FullName,
	ac.Manufacturer,
	ac.Model
	FROM FlightDestinations AS fd
	JOIN Airports AS a ON fd.AirportId = a.Id
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Aircraft AS ac ON fd.AircraftId = ac.Id
	WHERE (DATEPART(HOUR, fd.Start) >= 6 AND  DATEPART(HOUR, fd.Start) <= 20) AND
			fd.TicketPrice > 2500
	ORDER BY ac.Model

-----------------------------------------------

--Task 11 Find all Destinations by Email Address

GO
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
BEGIN
		RETURN (
		SELECT
			COUNT(fd.Id)
			FROM FlightDestinations AS fd
			JOIN Passengers AS p ON fd.PassengerId = p.Id
			WHERE p.Email = @email
		)
END
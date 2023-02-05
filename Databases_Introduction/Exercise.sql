-- Task 1 Create Database

CREATE DATABASE [Minions]

USE [Minions]

----------------------------------------------------

-- Problem 2 Create Tables

CREATE TABLE [Minions] (
Id INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
[Age] TINYINT NOT NULL
)

CREATE TABLE [Towns](
Id INT PRIMARY KEY NOT NULL,
[Name] NVARCHAR(50) NOT NULL
)

----------------------------------------------------

-- Task 3 Alter Minions Table

ALTER TABLE [Minions]
ADD TownId INT FOREIGN KEY REFERENCES Towns(Id)

-----------------------------------------------

-- Task 4 Insert Records in Both Tables

INSERT INTO Towns(Id, [Name])
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')


 INSERT INTO Minions(Id, [Name], Age, TownId)
 VALUES
 (1, 'Kevin', 22,1),
 (2, 'Bob', 15, 3),
 (3, 'Steward', NULL, 2)

-----------------------------------------------

 -- Task 5 Truncate Table Minions

 TRUNCATE TABLE [Minions]

-----------------------------------------------

 -- Task 6 Drop All Tables

 DROP TABLE [Minions]
 DROP TABLE [Towns]

-----------------------------------------------

 --Task 7 Create Table People

 CREATE TABLE People(
 Id INT PRIMARY KEY IDENTITY,
 [Name] NVARCHAR(200) NOT NULL,
 Picture VARBINARY(MAX) CHECK (DATALENGTH(Picture) <= 2000000 ),
 Height DECIMAL(3,2),
 [Weight] DECIMAL (5,2),
 Gender CHAR(1) CHECK(Gender ='m' OR Gender = 'f') NOT NULL,
 Birthdate DATE NOT NULL,
 Biography NVARCHAR(MAX)
 )

 INSERT INTO People ([Name],Height, [Weight], Gender, Birthdate, Biography)
 VALUES
 ('A', 'link', 1.24, 55.00, 'm','1999-05-25' ,'A'),
 ('B', 'link', 1.44, 55.00, 'm','1999-05-26' ,'B'),
 ('C', 'link', 1.54, 55.00, 'm','1999-05-27' ,'C'),
 ('D', 'link', 1.64, 55.00, 'm','1999-05-28' ,'D'),
 ('F', 'link', 1.74, 55.00, 'm','1999-05-29' ,'F')

-----------------------------------------------

 --Task 8 Create Table Users

CREATE TABLE Users
(
id INT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL UNIQUE,
Password VARCHAR(26) NOT NULL CHECK(LEN(Password) <= 26),
ProfilePicture VARBINARY(MAX) CHECK(DATALENGTH(ProfilePicture) <= 900000),
LastLoginTime DATETIME2,
IsDelited BIT
)

INSERT INTO Users(UserName, Password)
	VALUES
('A', 1234),
('B', 1234),
('C', 1234),
('D', 1234),
('E', 1234)

-----------------------------------------------

-- PROBLEM 9 Change Primary Key

ALTER TABLE Users
DROP CONSTRAINT id

ALTER TABLE Users
ADD CONSTRAINT PK_IdUsers PRIMARY KEY (Id, Username)

------------------------------------------------

-- PROBLEM 10 Add Check Constraint

ALTER TABLE Users
ADD CONSTRAINT PasswordCheck CHECK(LEN([Password]) >=5)

-----------------------------------------------

-- PROBLEM 11 Set Default Value of a Field

ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime
DEFAULT GETDATE() FOR LastLoginTime

-----------------------------------------------

-- PROBLEM 12 Set Unique Field

ALTER TABLE Users
DROP CONSTRAINT PK_IdUsers

ALTER TABLE Users
ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT DF_UsernameLength CHECK(LEN(Username) >=3)

DROP DATABASE Minions

-----------------------------------------------

-- PROBLEM 13 Movie Database

CREATE DATABASE Movies

CCREATE TABLE [Directors] (
    [Id] INT PRIMARY KEY IDENTITY,
    [DirectorName] NVARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(50)
)
CREATE TABLE [Genres] (
    [Id] INT PRIMARY KEY IDENTITY,
    [GenreName] NVARCHAR(30) NOT NULL,
    [Notes] NVARCHAR(50)
)
CREATE TABLE [Categories](
    [Id] INT PRIMARY KEY IDENTITY,
    [CategoryName] NVARCHAR(30) NOT NULL,
    [Notes] NVARCHAR(50)
)
CREATE TABLE [Movies] (
    [Id] INT PRIMARY KEY IDENTITY,
    [Title] NVARCHAR(50) NOT NULL,
    [DirectorName] INT FOREIGN KEY REFERENCES Directors(Id),
    [CopyrightYear] INT NOT NULL,
    [Length] TIME,
    [GenreId] INT FOREIGN KEY REFERENCES Genres(Id),
    [CategoryId] INT FOREIGN KEY REFERENCES Categories(Id),
    [Rating] DECIMAL (2,1),
    [Notes] NVARCHAR(50)
)

INSERT INTO Directors VALUES
('Ivan Ivanov', 'Barcelona'),
('Stan Petrov', 'Real'),
('Bat Sancho', 'Liverpool legend'),
('Krali Marko', 'World Champion'),
('Daniel Dinev', 'Very Talented')

INSERT INTO Genres VALUES
('Comedy', 'Funny...'),
('Action', 'Weapons'),
('Horror', 'Scary'),
('SciFi', 'Aliens'),
('Drama', 'OMG')

INSERT INTO Categories VALUES
('1', NULL),
('2', NULL),
('3', NULL),
('4', NULL),
('5', NULL)

INSERT INTO MOVIES VALUES
('Gosho', 1, 2020, '1:25:00', 1, 1, 9.9, 'Must Watch'),
('Sancho', 1, 1999, '1:40:00', 2, 4, 5.0, 'It is OK'),
('Naked', 2, 2099, '1:11:21', 3, 3, 5.3, 'WAS'),
('Joe', 4, 2019, '2:12:21', 4, 2, 5.8, 'Whiskey'),
('Carabas', 3, 2018, '1:30:01', 5, 1, 2.9, 'Rating')

-----------------------------------------------

--PROBLEM 14 Car Rental Database

CREATE DATABASE CarRental

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL,
	DailyRate INT NOT NULL,
	WeeklyRate INT NOT NULL,
	MonthlyRate INT NOT NULL,
	WeekendRate INT NOT NULL
)

CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber NVARCHAR(20) NOT NULL UNIQUE,
	Manufacturer NVARCHAR(30) NOT NULL,
	Model NVARCHAR(30) NOT NULL,
	CarYear INT NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Doors INT,
	Picture VARBINARY(MAX),
	Condition NVARCHAR(500),
	Available BIT NOT NULL
)

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Title NVARCHAR(30),
	Notes NVARCHAR(50)
)

CREATE TABLE Customers (
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber NVARCHAR(20) NOT NULL UNIQUE,
	FullName NVARCHAR(50) NOT NULL,
	Address NVARCHAR(100) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	ZIPCode NVARCHAR(30),
	Notes NVARCHAR(100)
)

CREATE TABLE RentalOrders (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
	CarId INT FOREIGN KEY REFERENCES Cars(Id),
	TankLevel INT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage AS KilometrageEnd - KilometrageStart,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	TotalDays AS DATEDIFF(DAY, StartDate, EndDate),
	RateApplied INT NOT NULL,
	TaxRate AS RateApplied * 0.2,
	OrderStatus BIT NOT NULL,
	Notes NVARCHAR(100)
)

INSERT INTO Categories VALUES
('Limousine', 65, 350, 1350, 120),
('SUV', 85, 500, 1800, 160),
('Economic', 40, 230, 850, 70)

INSERT INTO Cars VALUES
('A8877BB', 'Audi', 'A6', 2018, 1, 4, NULL, 'Good', 1),
('A8877CC', 'Lexus', 'IS', 2018, 3, 5, NULL, 'Very good', 0),
('A8877DD', 'BMW', 'X1', 2018, 2, 5, NULL, 'OK', 1)

INSERT INTO Employees VALUES
('Sancho', 'Pansa', NULL, NULL),
('Krali', 'Marko', NULL, NULL),
('Simbad', 'Carabas', 'DevOps', 'Employee of the year')

INSERT INTO Customers(DriverLicenceNumber, FullName, Address, City) VALUES
('AA11111BB', 'Michael Jackson', 'Jako str. 5', 'New York'),
('AA111111CC', 'Sergey Bubka', 'Bubka 7', 'Moskow'),
('AA111111DD', 'Franc Lampard', 'Franc str. 6', 'London')

INSERT INTO RentalOrders(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd,
StartDate, EndDate, RateApplied, OrderStatus) VALUES
(1, 2, 3, 45, 18005, 19855, '2007-08-08', '2007-08-10', 250, 1),
(3, 2, 1, 50, 55524, 56984, '2009-09-06', '2009-09-28', 1500, 0),
(2, 2, 1, 18, 36005, 38547, '2017-05-08', '2017-06-09', 850, 0)

-----------------------------------------------

--Task 15 Hotel Database

CREATE DATABASE Hotel

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Title NVARCHAR(50),
	Notes NVARCHAR(50)
)

CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	PhoneNumber NVARCHAR(30),
	EmergencyName NVARCHAR(30),
	EmergencyNumber NVARCHAR(30),
	Notes NVARCHAR(50)
)

CREATE TABLE RoomStatus (
	RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(50)
)

CREATE TABLE RoomTypes (
	RoomType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(50)
)

CREATE TABLE BedTypes (
	BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
	Notes NVARCHAR(50)
)

CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL,
	BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
	Rate DECIMAL(6,2) NOT NULL,
	RoomStatus BIT NOT NULL,
	Notes NVARCHAR(50)
)

CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATETIME NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
	AmountCharged DECIMAL(7, 2) NOT NULL,
	TaxRate DECIMAL(6,2) NOT NULL,
	TaxAmount AS AmountCharged * TaxRate,
	PaymentTotal AS AmountCharged + AmountCharged * TaxRate,
	Notes NVARCHAR(50)
)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATE NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied DECIMAL(7, 2) NOT NULL,
	PhoneCharge DECIMAL(8, 2) NOT NULL,
	Notes NVARCHAR(50)
)

INSERT INTO Employees(FirstName, LastNAme) VALUES
('Ivo', 'T'),
('Ivan', 'G'),
('Ivelin', 'F')

INSERT INTO Customers(FirstName, LastName, PhoneNumber) VALUES
('A', 'E', '+359888666555'),
('Z', 'Q', '+359866444222'),
('W', 'R', '+35977555333')

INSERT INTO RoomStatus(RoomStatus) VALUES
('occupied'),
('non occupied'),
('almost occupied')

INSERT INTO RoomTypes(RoomType) VALUES
('single'),
('double'),
('apartment')

INSERT INTO BedTypes(BedType) VALUES
('single'),
('double'),
('couch')

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus) VALUES
(111, 'single', 'single', 20.0, 1),
(112, 'double', 'double', 30.0, 0),
(132, 'apartment', 'double', 10.0, 1)

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, TaxRate) VALUES
(3, '2011-11-25', 2, '2017-11-30', '2017-12-04', 250.0, 0.2),
(2, '2014-06-03', 3, '2014-06-06', '2014-06-09', 340.0, 0.2),
(1, '2016-02-25', 2, '2016-02-27', '2016-03-04', 500.0, 0.2)

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge) VALUES
(2, '2015-01-01', 2, 111, 70.0, 12.54),
(2, '2017-01-02', 3, 112, 40.0, 11.22),
(3, '2018-01-03', 1, 132, 110.0, 10.05)

-----------------------------------------------

--Task 16 Create SoftUni Database

CREATE DATABASE SoftUni

CREATE TABLE Towns (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
AddressText NVARCHAR(120) NOT NULL,
TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE Departments(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Employees(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
JobTitle NVARCHAR(50) NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
HireDate DATE,
Salary DECIMAL(8,2),
AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

-----------------------------------------------

--Task 17 Backup Database

BACKUP DATABASE SoftUni TO DISK = 'C:\Users\q2kfo\OneDrive\Desktop\DB RESTORE\softuni-backup.bak'

-----------------------------------------------

--Task 18 Basic Insert

INSERT INTO Towns([Name])
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

-- Problem 19

SELECT * FROM Towns

SELECT * FROM Departments

SELECT * FROM Employees

-- Problem 20

SELECT * FROM Towns
ORDER BY [Name]

SELECT * FROM Departments
ORDER BY [Name]

SELECT * FROM Employees
ORDER BY Salary DESC

-- Problem 21

SELECT [Name] FROM Towns
ORDER BY [Name]

SELECT [Name] FROM Departments
ORDER BY [Name]

SELECT FirstName, LastName, JobTitle, Salary
FROM Employees
ORDER BY Salary DESC

-- Problem 22

UPDATE Employees
SET Salary *= 1.1

SELECT Salary FROM Employees

--Problem 23

USE Hotel
UPDATE Payments
SET TaxRate -= TaxRate*0.03
SELECT TaxRate FROM Payments

--Problem 24
TRUNCATE TABLE Occupancies
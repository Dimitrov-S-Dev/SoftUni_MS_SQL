-- Task 9 => Change Primary Key
-- Using SQL queries modify table Users from the previous task.
--First remove the current primary key and then create a new primary key
--that would be a combination of fields Id and Username.

ALTER Table [Users]
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username)

-- Task 10 => Add Check Constraint
-- Add check constraint to ensure that the values in
--the Password field are at least 5 symbols long.

ALTER TABLE [Users]
ADD CONSTRAINT CH_Pass_Is_More_Then_Five CHECK (LEN([Password]) >= 5)

-- Task 11 => Set Default Value of a Field
-- Make the default value of
--LastLoginTime field to be the current time.

ALTER TABLE [Users]
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR [LastLoginTime]

-- Task 12 => Set Unique Field
--Remove Username field from the primary key so only the field Id would be primary key.
--Now add unique constraint to the Username field to ensure that the values there are at least 3 symbols long.

ALTER TABLE [Users]
DROP CONSTRAINT PK_IdUsername

ALTER TABLE [Users]
ADD CONSTRAINT PK_UserName PRIMARY KEY (Id)

ALTER TABLE [Users]
ADD CONSTRAINT CH_UserName_Length CHECK(LEN(Username) >= 3)

-- Task 13 => Movies Database
--create Movies database with the following entities:
--· Directors (Id, DirectorName, Notes)
--· Genres (Id, GenreName, Notes)
--· Categories (Id, CategoryName, Notes)
--· Movies (Id, Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
--Set the most appropriate data types for each column.
--Set a primary key to each table.
--Populate each table with exactly 5 records.
--Make sure the columns that are present in 2 tables would be of the same data type.
--Consider which fields are always required and which are optional.
--Submit your CREATE TABLE and INSERT statements as Run queries & check DB.

CREATE Database [Movies]

CREATE TABLE [Directors] (
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

-- Task 14
-- Using SQL queries create CarRental database with the following entities:
--· Categories (Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
--· Cars (Id, PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
--· Employees (Id, FirstName, LastName, Title, Notes)
--· Customers (Id, DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
--· RentalOrders (Id, EmployeeId, CustomerId, CarId, TankLevel, \
--KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays,\
--RateApplied, TaxRate, OrderStatus, Notes)
--Set the most appropriate data types for each column.
--Set a primary key to each table. Populate each table with only 3 records.
--Make sure the columns that are present in 2 tables would be of the same data type.
--Consider which fields are always required and which are optional.
--Submit your CREATE TABLE and INSERT statements as Run queries & check DB.


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



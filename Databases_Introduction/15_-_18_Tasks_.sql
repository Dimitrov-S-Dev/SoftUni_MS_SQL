-- Task 15 => Hotel Database
-- create Hotel database with the following entities:
--· Employees (Id, FirstName, LastName, Title, Notes)
--· Customers (AccountNumber, FirstName, LastName, PhoneNumber,
--EmergencyName, EmergencyNumber, Notes)
--· RoomStatus (RoomStatus, Notes)
--· RoomTypes (RoomType, Notes)
--· BedTypes (BedType, Notes)
--· Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
--· Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays,
--AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
--· Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
--Set the most appropriate data types for each column.
--Set a primary key to each table.
--Populate each table with only 3 records.
--Make sure the columns that are present in 2 tables would be of the same data type.
--Consider which fields are always required and which are optional.
--Submit your CREATE TABLE and INSERT statements as Run queries & check DB.

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

-- Task 16 => Create SoftUni Database
--create bigger database called SoftUni.
--You will use the same database in the future tasks.
--It should hold information about
--· Towns (Id, Name)
--· Addresses (Id, AddressText, TownId)
--· Departments (Id, Name)
--· Employees (Id, FirstName, MiddleName, LastName, JobTitle, DepartmentId,\
--HireDate, Salary, AddressId)
--The Id columns are auto incremented, starting from 1 and increased by 1
--(1, 2, 3, 4…). Make sure you use appropriate data types for each column.
--Add primary and foreign keys as constraints for each table.
--Use only SQL queries.
--Consider which fields are always required and which are optional.

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

-- Task 17 => Backup Database
--Backup the database SoftUni from the previous task into a file named "softuni-backup.bak".
--Delete you database from SQL Server Management Studio.
--Then restore the database from the created backup.

BACKUP DATABASE SoftUni TO DISK = 'C:\Users........

-- Task 18 => Basic Insert
-- Use the SoftUni database and insert some data using SQL queries.
--· Towns: Sofia, Plovdiv, Varna, Burgas
--· Departments: Engineering, Sales, Marketing, Software Development,Quality Assurance
--· Employees:
--Name Job Title Department Hire Date Salary
--Ivan Ivanov Ivanov .NET Developer Software Development 01/02/2013 3500.00
--Petar Petrov Petrov Senior Engineer Engineering 02/03/2004 4000.00
--Maria Petrova Ivanova Intern Quality Assurance 28/08/2016 525.25
--Georgi Teziev Ivanov CEO Sales 09/12/2007 3000.00
--Peter Pan Pan Intern Marketing 28/08/2016 599.88

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
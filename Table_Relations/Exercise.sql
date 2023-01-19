-- Task 1

CREATE DATABASE [One_To_One]

USE One_To_One

CREATE TABLE Passports
(
[PassportID] INT PRIMARY KEY IDENTITY(101,1),
[PassportNumber] VARCHAR(10) NOT NULL

)

CREATE TABLE [Persons]
(
[PersonID] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(30) NOT NULL,
[Salary] DECIMAL(8,2) NOT NULL,
[PassportID] INT REFERENCES Passports([PassportID]) UNIQUE NOT NULL
)


INSERT INTO [Passports] ([PassportNumber])
	VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')


INSERT INTO [Persons]([FirstName], [Salary], [PassportID])
	VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)

-- Task 2

CREATE TABLE [Manufacturers]
(
[ManufacturerID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL,
[EstablishedOn] DATE NOT NULL
)

CREATE TABLE [Models]
(
[ModelID] INT PRIMARY KEY IDENTITY(101, 1),
[Name] VARCHAR(30) NOT NULL,
[ManufacturerID] INT REFERENCES [Manufacturers]([ManufacturerID]) NOT NULL
)


INSERT INTO [Manufacturers]([Name], [EstablishedOn])
	VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

GO

INSERT INTO [Models] ([Name], [ManufacturerID])
	VALUES
('X1', 1),
('i6', 1),
('ModelS', 2),
('ModelX', 2),
('Model3', 2),
('Nova', 3)

-- Task 3

CREATE TABLE [Students]
(
[StudentID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(40) NOT NULL
)


CREATE TABLE [Exams]
(
[ExamID] INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(70) NOT NULL
)



CREATE TABLE [StudentsExams]
(
[StudentID] INT REFERENCES [Students](StudentID),
[ExamID] INT REFERENCES [Exams]([ExamID]),
PRIMARY KEY ([StudentID], [ExamID])

)

INSERT INTO [Students] ([Name])
	VALUES
('Mila'),
('Toni'),
('Ron')


INSERT INTO [Exams] ([Name])
	VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')


INSERT INTO [StudentsExams] ([StudentID], [ExamID])
	VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)


-- Task 4


CREATE TABLE [Teachers]
(
[TeacherID] INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(50) NOT NULL,
[ManagerID] INT REFERENCES [Teachers](TeacherID)
)

INSERT INTO [Teachers]([Name], [ManagerID])
	VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta',101)


-- Task 5


CREATE TABLE [Cities]
(
[CityID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Customers]
(
[CustomerID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[Birthday] DATE,
[CityID] INT REFERENCES [Cities]([CityID])
)

CREATE TABLE [Orders]
(
[OrderID] INT PRIMARY KEY IDENTITY,
[CustomerID] INT REFERENCES [Customers]([CustomerID])
)

CREATE TABLE [ItemTypes]
(
[ItemTypeID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Items]
(
[ItemID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[ItemTypeID] INT REFERENCES [ItemTypes]([ItemTypeID])
)

CREATE TABLE [OrderItems]
(
[OrderID] INT REFERENCES [Orders]([OrderID]),
[ItemID] INT REFERENCES [Items]([ItemID])
PRIMARY KEY ([OrderID],[ItemID])
)

-- Task 6

CREATE TABLE [Majors]
(
[MajorID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Subjects]
(
[SubjectID] INT PRIMARY KEY IDENTITY,
[SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
[StudentID] INT PRIMARY KEY IDENTITY,
[StudentNumber] INT NOT NULL,
[StudentName] NVARCHAR(50) NOT NULL,
[MajorID] INT REFERENCES Majors(MajorID)
)

Create TABLE [Agenda]
(
[StudentID] INT REFERENCES [Students]([StudentID]),
[SubjectID] INT REFERENCES Subjects([SubjectID])
PRIMARY KEY ([StudentID], [SubjectID])

)

CREATE TABLE [Payments]
(
[PaymentID] INT PRIMARY KEY IDENTITY,
[PaymentDate] DATETIME2 NOT NULL,
[PaymentAmount] DECIMAL(8,2),
[StudentID] INT REFERENCES [Students]([StudentID]) NOT NULL
)



-- Task 9

   SELECT [m].[MountainRange], [p].[PeakName], [p].[Elevation]
	FROM  [Mountains] AS [m]
LEFT JOIN [Peaks]    AS [p]
	ON [p].[MountainId] = [m] .[ID]
	WHERE [MountainRange] = 'Rila'
	ORDER BY [p].[Elevation] DESC

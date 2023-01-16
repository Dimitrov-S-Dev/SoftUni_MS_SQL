-- Task 1 => Create Database
-- create new database named Minions

CREATE DATABASE [Minions]

--Task 2 => Create Tables
-- In the newly created database Minions add table Minions (Id, Name, Age).
--Then add a new table Towns (Id, Name).
--Set Id columns of both tables to be primary key as constraint.

CREATE TABLE [Minions] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT

)

CREATE TABLE [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL

)

-- Task 3 => Alter Minions Table
-- Change the structure of the Minions table to have a new column TownId
--that would be of the same type as the Id column in Towns table.
--Add a new constraint that makes TownId foreign key and references to Id column in Towns table.

ALTER TABLE [Minion]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns](Id) NOT NULL

-- Task 4 => Insert Records in Both Tables
--Populate both tables with sample records, given in the table below.
--Minions Towns
--Id Name Age TownId Id Name
--1 Kevin 22 1 1 Sofia
--2 Bob 15 3 2 Plovdiv
--3 Steward NULL 2 3 Varna
--Use only SQL queries. Insert the Id manually (don't use identity).

INSERT INTO [Towns] ([Id], [Name])
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO [Minions] ([Id], [Name], [Age], [TownId])
VALUES
(1, 'Kevin', 22, 1)
(2, 'Bob', 15, 3)
(3, 'Steward', NULL, 2)


-- Task 5 => Truncate Table Minions
--Delete all the data from the Minions table using SQL query.

TRUNCATE TABLE [Minions]

-- Task 6 => Drop All Tables
--Delete all tables from the Minions database using SQL query.

DROP TABLE [Minions]
DROP TABLE [Towns]

-- Task 7 => Create Table People
--Using SQL query, create table People with the following columns:
--· Id – unique number. For every person there will be no more than
--231-1 people (auto incremented).
--· Name – full name of the person.
--There will be no more than 200 Unicode characters (not null).
--· Picture – image with size up to 2 MB (allow nulls).
--· Height – in meters. Real number precise up to 2 digits after floating point
--(allow nulls).
--· Weight – in kilograms. Real number precise up to 2 digits after floating point
--(allow nulls).
--· Gender – possible states are m or f (not null).
--· Birthdate – (not null).
--· Biography – detailed biography of the person.
--It can contain max allowed Unicode characters (allow nulls).
--Make the Id a primary key. Populate the table with only 5 records.
--Submit your CREATE and INSERT statements as Run queries & check DB

CREATE TABLE [People](
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(200) NOT NULL,
    [Picture] VARBINARY (MAX),
    CHECK (DATALENGTH ([Picture]) <= 2000000),
    [Height] DECIMAL (5,2),
    [Weight] DECIMAL (5,2),
    [Gender] CHAR(1) NOT NULL,
    CHECK ([Gender] == 'm' OR [Gender] == 'f'),
    [Birthdate] DATE NOT NULL,
    [Biography] NVARCHAR(MAX)
)

INSERT INTO [People] ([Name], [Height], [Weight], [Gender], [Birthdate])
VALUES
('Pesho', 1.77, 75.2, 'm', '1998-05-25'),
('Gosho',NULL, NULL, 'm', '1977-11-05'),
('Maria', 1.65, 42.2, 'f', '1998-06-27'),
('Viki',NULL, NULL, 'f', '1986-02-02'),
('Vancho', 1.69, 77.8, 'm', '1999-03-03')

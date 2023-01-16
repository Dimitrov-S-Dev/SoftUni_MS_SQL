-- Task 1
-- create new database named Minions

CREATE DATABASE [Minions]

--Task 2
-- In the newly created database Minions add table Minions (Id, Name, Age).
--Then add a new table Towns (Id, Name).
--Set Id columns of both tables to be primary key as constraint.

CREATE Table [Minions] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT

)

CREATE Table [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL

)

-- Task 3
-- Change the structure of the Minions table to have a new column TownId
--that would be of the same type as the Id column in Towns table.
--Add a new constraint that makes TownId foreign key and references to Id column in Towns table.

ALTER Table [Minion]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns](Id) NOT NULL

-- Task 4
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
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


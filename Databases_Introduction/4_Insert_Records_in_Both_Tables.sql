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
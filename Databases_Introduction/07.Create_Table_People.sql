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

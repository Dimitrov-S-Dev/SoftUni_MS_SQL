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


-- Task 1
CREATE DATABASE [Minions]

-- Task 2

CREATE Table [Minions] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT NOT NULL

)

CREATE Table [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL

)

-- Task 3

ALTER Table [Minion]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns](Id) NOT NULL


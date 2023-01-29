
--Section 1 DDL 1.Database Design

CREATE DATABASE BitBucket

GO

USE BitBucket

GO

CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(30) NOT NULL,
Email VARCHAR(50) NOT NULL
)

CREATE Table Repositories
(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL
)

CREATE Table RepositoriesContributors
(
RepositoryId INT REFERENCES Repositories(Id),
ContributorId INT REFERENCES Users(Id)
PRIMARY KEY(RepositoryId, ContributorId)
)

CREATE TABLE Issues
(
Id INT PRIMARY KEY IDENTITY,
Title VARCHAR(255) NOT NULL,
IssueStatus VARCHAR(6) NOT NULL,
RepositoryId INT REFERENCES Repositories(Id) NOT NULL,
AssigneeId INT REFERENCES Users(Id) NOT NULL
)

CREATE Table Commits
(
Id INT PRIMARY KEY IDENTITY,
Message VARCHAR(255) NOT NULL,
IssueId INT REFERENCES Issues(Id),
RepositoryId INT REFERENCES Repositories(Id) NOT NULL,
ContributorId INT REFERENCES Users(Id) NOT NULL
)

CREATE Table Files
(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
Size DECIMAL(15, 2) NOT NULL,
ParentId INT REFERENCES Files(Id),
CommitId INT REFERENCES Commits(Id) NOT NULL
)

--2.Insert

GO

INSERT INTO Files([Name],[Size],[ParentId],[CommitId])
	VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix',7662.92, 7, 7)

GO

INSERT INTO Issues(Title, IssueStatus, RepositoryId, AssigneeId)
	VALUES

('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)

GO

--Task 3 Update

Update Issues
SET IssueStatus = 'closed'
WHERE AssigneeId = 6

--Task 4 Delete
-- Check what is refering what befero start Delete

DELETE  FROM RepositoriesContributors
WHERE RepositoryId = (SELECT
						Id
						FROM Repositories
						WHERE Name = 'Softuni-Teamwork'
						)




DELETE  FROM Commits
WHERE RepositoryId = (SELECT
						Id
						FROM Repositories
						WHERE Name = 'Softuni-Teamwork'
						)



-- Take all Ids of Issues that Ineed to delete
SELECT Id
	FROM Issues
	WHERE RepositoryId = (SELECT
						Id
						FROM Repositories
						WHERE Name = 'Softuni-Teamwork'
						)

-- No such commits refering this Issue
DELETE FROM Commits
WHERE IssueId IN(
			SELECT Id
	FROM Issues
	WHERE RepositoryId = (SELECT
						Id
						FROM Repositories
						WHERE Name = 'Softuni-Teamwork'
						)
)


DELETE FROM Issues
WHERE RepositoryId = (
					SELECT
					Id
					FROM Repositories
					WHERE Name = 'Softuni-Teamwork')

--Task 5 Commits

SELECT
	Id,
	[Message],
	RepositoryId,
	ContributorId
	FROM Commits
	ORDER BY Id,
	[Message],
	RepositoryId,
	ContributorId

--Task 6 Front-end

SELECT
	Id,
	Name,
	Size
	FROM Files
	WHERE Size > 1000 AND Name LIKE '%html'
	ORDER BY Size DESC,
	Id,
	Name


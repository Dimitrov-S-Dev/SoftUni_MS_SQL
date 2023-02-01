
--Task 1 DDL Database Design

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

--Task 2 Insert

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



-- Take all Ids of Issues that I need to delete
SELECT Id
	FROM Issues
	WHERE RepositoryId = (SELECT
						Id
						FROM Repositories
						WHERE Name = 'Softuni-Teamwork'
						)

-- No such commits referring this Issue
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

--Task 7 Issue Assignment

SELECT
	i.Id,
	CONCAT_WS(':',u.Username, i.Title) AS IssueAssignee
	FROM Issues AS i
	JOIN Users AS u ON i.AssigneeId = u.Id
	ORDER BY i.Id DESC,
	i.AssigneeId

--Task 8 Single Files

SELECT f.Id, f.[Name], CONCAT(f.Size, 'KB') AS Size
	FROM Files f
	WHERE f.Id  NOT IN
    (SELECT f1.ParentId
    FROM Files f1
    WHERE f1.ParentId IS NOT NULL)
	ORDER BY f.Id, f.[Name], Size DESC

--Task 9 Commits in Repositories

SELECT
	TOP 5
	r.Id,
	r.[Name],
	COUNT(c.Id) AS Commits
	FROM Repositories AS r
LEFT JOIN Commits AS c ON c.RepositoryId = r.Id
LEFT JOIN RepositoriesContributors AS rc ON rc.RepositoryId = r.Id
	GROUP BY r.Id, r.[Name]
	ORDER BY Commits DESC,
	r.Id,
	r.[Name]


--Task 10 Average Size

SELECT
	u.Username,
	AVG(f.Size) AS Size
	FROM Users AS u
	JOIN Commits AS c ON u.Id = c.ContributorId
	JOIN Files AS f ON f.CommitId = c.Id
	GROUP BY u.Username
	ORDER BY Size DESC,
		u.Username

--Task 11 All User Commits

GO
CREATE OR ALTER FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @userId INT = (
		SELECT Id
		FROM Users
		WHERE Username = @username
	)
	DECLARE @commitsCnt INT = (
		SELECT COUNT(Id)
		FROM Commits
		WHERE ContributorId = @userId
	)
	RETURN @commitsCnt
END
GO

--Task 12 Search for Files

CREATE OR ALTER PROCEDURE usp_SearchForFiles @fileExtension VARCHAR(98)
AS
BEGIN
		SELECT
		f.Id,
		f.[Name],
		CONCAT(f.Size, 'KB') AS Size
		FROM [Files] AS f
		WHERE [Name] LIKE CONCAT('%[.]', @fileExtension)
		ORDER BY f.Id,
		f.[Name],
		f.Size DESC
END

END
GO

EXEC usp_SearchForFiles 'txt'

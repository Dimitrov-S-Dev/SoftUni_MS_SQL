
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
-- Task 8 => Create Table Users
-- create table Users with columns:
--· Id – unique number for every user.
--There will be no more than 2** 63-1 users (auto incremented).
--· Username – unique identifier of the user.
--It will be no more than 30 characters (non Unicode) (required).
--· Password – password will be no longer than 26 characters
--(non Unicode) (required).
--· ProfilePicture – image with size up to 900 KB.
--· LastLoginTime
--· IsDeleted – shows if the user deleted his/her profile.
--Possible states are true or false.
--Make the Id a primary key.
--Populate the table with exactly 5 records.
--Submit your CREATE and INSERT statements as Run queries & check DB.


CREATE TABLE [Users] (
    [Id] BIGINT PRIMARY KEY IDENTITY,
    [Username] VARCHAR(30) UNIQUE NOT NULL,
    [Password] VARCHAR(26) NOT NULL,
    [ProfilePicture] VARBINARY(MAX),
    CHECK(DATALENGTH(ProfilePicture) < 900 * 1000),
    [LastLoginTime] DATETIME 2,
    [IsDeleted] BIT
)

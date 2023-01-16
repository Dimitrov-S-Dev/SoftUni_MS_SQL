-- Task 8 => Create Table Users
--create table Users with columns:
--· Id – unique number for every user.
--There will be no more than 263-1 users (auto incremented).
--· Username – unique identifier of the user.
--It will be no more than 30 characters (non Unicode) (required).
--· Password – password will be no longer than 26 characters
--(non Unicode) (required).
--· ProfilePicture – image with size up to 900 KB.
--· LastLoginTime
--· IsDeleted – shows if the user deleted his/her profile.
--Possible states are true or false.
--Make the Id a primary key. Populate the table with exactly 5 records.
--Submit your CREATE and INSERT statements as Run queries & check DB.

CREATE TABLE [Users] (
    [Id] BIGINT PRIMARY KEY IDENTITY,
    [Username] VARCHAR(30) UNIQUE NOT NULL,
    [Password] VARCHAR(26) NOT NULL,
    [ProfilePicture] VARBINARY(MAX),
    CHECK (DATALENGTH([ProfilePicture]) <= 900 * 1000),
    [LastLoginTime] DATETIME 2,
    [IsDeleted] BIT

)
INSERT INTO [Users](
    [Username],
    [Password],
    [ProfilePicture],
    [LastLoginTime],
    [IsDeleted]
)
VALUES
('stoshop', 'strohpass123', 'https://avatars.githubusercontent.com/u/22989000?v=4', '1/12/2021',0),
('petshop', 'pethpass123', 'https://avatars.githubusercontent.com/u/22989000?v=4', '2/12/2021', 0),
('metshop', 'methpass123', 'https://avatars.githubusercontent.com/u/22989000?v=4', '3/12/2021', 0),
('netshop', 'nethpass123', 'https://avatars.githubusercontent.com/u/22989000?v=4', '4/12/2021', 0),
('betshop', 'bethpass123', 'https://avatars.githubusercontent.com/u/22989000?v=4', '5/12/2021', 0)

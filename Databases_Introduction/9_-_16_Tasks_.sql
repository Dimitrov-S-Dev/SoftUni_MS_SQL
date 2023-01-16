-- Task 9
-- Using SQL queries modify table Users from the previous task.
--First remove the current primary key and then create a new primary key
--that would be a combination of fields Id and Username.

ALTER Table [Users]
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username)

-- Task 10
-- Add check constraint to ensure that the values in
--the Password field are at least 5 symbols long.

ALTER TABLE [Users]
ADD CONSTRAINT CH_Pass_Is_More_Then_Five CHECK (LEN([Password]) >= 5)

-- Task 11
-- Make the default value of
--LastLoginTime field to be the current time.

ALTER TABLE [Users]
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR [LastLoginTime]

-- Task 12
--Remove Username field from the primary key so only the field Id would be primary key.
--Now add unique constraint to the Username field to ensure that the values there are at least 3 symbols long.

ALTER TABLE [Users]
DROP CONSTRAINT PK_IdUsername

ALTER TABLE [Users]
ADD CONSTRAINT PK_UserName PRIMARY KEY (Id)

ALTER TABLE [Users]
ADD CONSTRAINT CH_UserName_Length CHECK(LEN(Username) >= 3)


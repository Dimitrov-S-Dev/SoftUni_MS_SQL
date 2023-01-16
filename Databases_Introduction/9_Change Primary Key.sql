-- Task 9
-- Using SQL queries modify table Users from the previous task.
--First remove the current primary key and then create a new primary key
--that would be a combination of fields Id and Username.

ALTER Table [Users]
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username)

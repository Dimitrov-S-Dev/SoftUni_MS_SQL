-- Task 12 => Set Unique Field
--Remove Username field from the primary key so only the field Id would be primary key.
--Now add unique constraint to the Username field to ensure that the values there are at least 3 symbols long.

ALTER TABLE [Users]
DROP CONSTRAINT PK_IdUsername

ALTER TABLE [Users]
ADD CONSTRAINT PK_UserName PRIMARY KEY (Id)

ALTER TABLE [Users]
ADD CONSTRAINT CH_UserName_Length CHECK(LEN(Username) >= 3)

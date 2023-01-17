-- Task 11 => Set Default Value of a Field
-- Make the default value of
--LastLoginTime field to be the current time.

ALTER TABLE [Users]
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR [LastLoginTime]

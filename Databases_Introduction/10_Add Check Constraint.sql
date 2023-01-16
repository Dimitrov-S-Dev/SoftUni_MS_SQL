-- Task 10
-- Add check constraint to ensure that the values in
--the Password field are at least 5 symbols long.

ALTER TABLE [Users]
ADD CONSTRAINT CH_Pass_Is_More_Then_Five CHECK (LEN([Password]) >= 5)

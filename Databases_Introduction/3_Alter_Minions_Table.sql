-- Task 3 => Alter Minions Table
-- Change the structure of the Minions table to have a new column TownId
--that would be of the same type as the Id column in Towns table.
--Add a new constraint that makes TownId foreign key and references to Id column in Towns table.

ALTER TABLE [Minion]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns](Id) NOT NULL
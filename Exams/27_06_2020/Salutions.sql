----Task 1 DDL Database Design
CREATE DATABASE WMS
GO

USE WMS
GO

CREATE TABLE Clients
(
ClientId INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Phone CHAR(12) CHECK(LEN(Phone)= 12) NOT NULL
)

GO

CREATE TABLE Mechanics
(
MechanicId INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
[Address] VARCHAR(255) NOT NULL
)

GO


CREATE TABLE Models
(
ModelId INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) UNIQUE NOT NULL
)

GO

CREATE TABLE Jobs
(
JobId INT PRIMARY KEY IDENTITY,
ModelId INT REFERENCES Models(ModelId) NOT NULL,
[Status] VARCHAR(11) DEFAULT 'Pending' CHECK([Status] IN('Pending', 'In Progress','Finished')) NOT NULL,
ClientId INT REFERENCES Clients(ClientId) NOT NULL,
MechanicId INT REFERENCES Mechanics(MechanicId),
IssueDate DATE NOT NULL,
FinishDate DATE
)

GO

CREATE TABLE Orders
(
OrderId INT PRIMARY KEY IDENTITY,
JobId INT REFERENCES Jobs(JobId) NOT NULL,
IssueDate DATE,
Delivered BIT DEFAULT 0
)
GO

CREATE TABLE Vendors
(
VendorId INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) UNIQUE NOT NULL
)
GO

CREATE TABLE Parts
(
PartId INT PRIMARY KEY IDENTITY,
SerialNumber VARCHAR(50) UNIQUE NOT NULL,
Description VARCHAR(255),
Price DECIMAL(6, 2) CHECK(Price > 0 AND Price <= 9999.99) NOT NULL,
VendorId INT REFERENCES Vendors(VendorId) NOT NULL,
StockQty INT DEFAULT 0 CHECK(StockQty >= 0)
)
GO

CREATE TABLE OrderParts
(
OrderId INT REFERENCES Orders(OrderId),
PartId INT REFERENCES Parts(PartId),
Quantity INT DEFAULT 1 CHECK(Quantity > 0),
PRIMARY KEY(OrderId, PartId)
)
GO

CREATE TABLE PartsNeeded
(
JobId INT REFERENCES Jobs(JobId),
PartId INT REFERENCES Parts(PartId),
Quantity INT DEFAULT 1 CHECK(Quantity > 0),
PRIMARY KEY(JobId, PartId)
)


--Task 2  Insert

INSERT INTO Clients(FirstName, LastName, Phone)
	VALUES
('Teri', 'Ennaco', '570-889-5187'),
('Merlyn',	'Lawler','201-588-7810'),
('Georgene',	'Montezuma','925-615-5185'),
('Jettie',	'Mconnell',	'908-802-3564'),
('Lemuel',	'Latzke',	'631-748-6479'),
('Melodie',	'Knipp',	'805-690-1682'),
('Candida',	'Corbley',	'908-275-8357')

INSERT INTO Parts(SerialNumber, [Description], Price, VendorId)
	VALUES
('WP8182119','Door Boot Seal', '117.86', 2),
('W10780048','Suspension Rod',	'42.81', 1),
('W10841140','Silicone Adhesive', '6.77', 4),
('WPY055980', 'High Temperature Adhesive','13.94', 3)

--Task 3 Update

UPDATE Jobs
	SET MechanicId = 3,
		Status = 'In Progress'
	WHERE Status = 'Pending'



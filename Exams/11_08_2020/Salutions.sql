--Task 1 DDL

CREATE DATABASE Bakery

GO

USE Bakery


CREATE TABLE Countries
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) UNIQUE
)


CREATE TABLE Customers
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(25),
LastName NVARCHAR(25),
Gender CHAR(1) CHECK(Gender IN('M','F')),
Age INT,
PhoneNumber CHAR(10) CHECK(LEN(PhoneNumber) = 10),
CountryId INT REFERENCES Countries(Id)
)

CREATE TABLE Products
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) UNIQUE,
[Description] NVARCHAR(250),
Recipe NVARCHAR(MAX),
Price DECIMAL(18, 2) CHECK(Price >= 0)
)

CREATE TABLE Feedbacks
(
Id INT PRIMARY KEY IDENTITY,
[Description] NVARCHAR(255),
Rate DECIMAL(4,2) CHECK(Rate >= 0 AND Rate <= 10),
ProductId INT REFERENCES Products(Id),
CustomerId INT REFERENCES Customers(Id)
)

CREATE TABLE Distributors
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) UNIQUE,
AddressText NVARCHAR(30),
Summary NVARCHAR(200),
CountryId INT REFERENCES Countries(Id)
)

CREATE TABLE Ingredients
(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30),
[Description] NVARCHAR(200),
OriginCountryId INT REFERENCES Countries(Id),
DistributorId INT REFERENCES Distributors(Id)
)


CREATE TABLE ProductsIngredients
(
ProductId INT REFERENCES Products(Id),
IngredientId INT REFERENCES Ingredients(Id),
PRIMARY KEY(ProductId, IngredientId)
)

-----------------------------------------------

--Task 2 Insert

INSERT INTO Distributors([Name] , CountryId, AddressText, Summary)
	VALUES
	('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
	('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
	('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
	('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus [group]'),
	('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

INSERT INTO Customers(FirstName, LastName, Age, Gender, PhoneNumber, CountryId)
	VALUES
	('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
	('Kendra', 'Loud', 22, 'F', '0063631526', 11),
	('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8),
	('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
	('Tom', 'Loeza', 31, 'M', '0144876096', 23),
	('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
	('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
	('Josefa', 'Opitz', 43, 'F', '0197887645', 17)

-----------------------------------------------

--Task 3 Update

UPDATE Ingredients
SET DistributorId = 35
WHERE Name IN('Bay Leaf', 'Paprika','Poppy')

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8

-----------------------------------------------

--Task 4 Delete


DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5

-----------------------------------------------

--Task 5 Products by Price

SELECT
	Name,
	Price,
	Description
	FROM Products
	ORDER BY Price DESC,
	Name

-----------------------------------------------

--Task 6 Negative Feedback

SELECT
	f.ProductId,
	f.Rate,
	f.Description,
	c.Id,
	c.Age,
	c.Gender
	FROM Feedbacks AS f
	JOIN Customers AS c ON f.CustomerId = c.Id
	WHERE f.Rate < 5.0
	ORDER BY ProductId DESC,
	f.Rate

-----------------------------------------------

--Task 7 Customers without Feedback

SELECT
	CONCAT_WS(' ', c.FirstName, c.LastName) AS CustomerName,
	c.PhoneNumber,
	c.Gender
	FROM Feedbacks AS f
	RIGHT JOIN Customers AS c ON f.CustomerId = c.Id
	WHERE f.Id IS NULL


--Task 8 Customers by Criteria

SELECT
	FirstName,
	Age,
	PhoneNumber
	FROM Customers
	WHERE Age >= 21 AND (FirstName LIKE '%an%' OR PhoneNumber LIKE '%38') AND CountryId != 31
	ORDER BY FirstName,
	Age DESC


--Task 9 Middle Range Distributors

SELECT
	d.Name,
	i.Name,
	p.Name,
	AVG(f.Rate) AS AverageRate
	FROM Ingredients AS i
	JOIN Distributors AS d ON i.DistributorId = d.Id
	JOIN ProductsIngredients AS pin ON i.Id = pin.IngredientId
	JOIN Products AS p ON pin.ProductId = p.Id
	JOIN Feedbacks AS f ON f.ProductId = p.Id
	GROUP BY d.Name,i.Name,p.Name
	HAVING AVG(f.Rate) BETWEEN 5 AND 8
	ORDER BY d.Name,
	i.Name,
	p.Name

--Task 10 Country Representative

SELECT CountryName,DisributorName from (
SELECT
c.Name as CountryName,
d.Name as DisributorName,
DENSE_RANK() OVER
(
    PARTITION BY c.Name
    ORDER BY COUNT(i.DistributorId) DESC

) as orderRank

FROM Countries AS c
left JOIN Distributors AS d ON d.CountryId=c.Id
left JOIN Ingredients AS i ON d.Id=i.DistributorId
GROUP BY c.Name,d.Name) as innerSelection
WHERE orderrank = 1
ORDER BY CountryName,DisributorName;

--Task 1 Record's Count

SELECT
	COUNT(*) AS Count
	FROM WizzardDeposits

--Task 2 Longest Magic Wand

SELECT
	MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits

--Task 3 Longest Magic Wand Per Deposit Groups

SELECT
	DepositGroup,
	MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits
	GROUP BY DepositGroup

--Task 4 Smallest Deposit Group Per Magic Wand Size

SELECT
	TOP 2
	DepositGroup
	FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

--Task 5 Deposit Sum

SELECT
	TOP 5
	DepositGroup,
	SUM(DepositAmount)
	FROM WizzardDeposits
	GROUP BY DepositGroup

--Task 6 Deposit Sum for Ollivander Family

SELECT
	DepositGroup,
	SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

--Task 7 Deposit Filter

SELECT
	DepositGroup,
	SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) < 150000
	ORDER BY TotalSum DESC

--Task 8 Deposite Charge

SELECT
	DepositGroup,
	MagicWandCreator,
	MIN(DepositCharge) AS MinDepositCharge
	FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator,
	DepositGroup

--Task 9 Age Groups

SELECT a.AgeGroup, COUNT(*) AS WizardCount FROM
	(SELECT
		CASE
		WHEN Age <= 10 THEN '[0-10]'
		WHEN Age <= 20 THEN '[11-20]'
		WHEN Age <= 30 THEN '[21-30]'
		WHEN Age <= 40 THEN '[31-40]'
		WHEN Age <= 50 THEN '[41-50]'
		WHEN Age <= 60 THEN '[51-60]'
		ELSE '[61+]'
		END AS AgeGroup
		FROM WizzardDeposits) AS a
	GROUP BY a.AgeGroup
	ORDER BY a.AgeGroup

--Task 10 First Letter

SELECT LEFT(FirstName,1) AS FirstLetter
	FROM WizzardDeposits
	WHERE DepositGroup LIKE 'Troll%'
	GROUP BY LEFT(FirstName, 1)
	ORDER BY FirstLetter

--Task 11 Average Interest

SELECT
	DepositGroup,
	IsDepositExpired,
	AVG(DepositInterest)
	FROM WizzardDeposits
	WHERE DepositStartDate > '1985-01-01'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC,
	IsDepositExpired

--Task 13 Departments Total Salaries

SELECT
	DepartmentID,
	SUM(Salary) AS TotalSalary
	FROM Employees
	GROUP BY DepartmentID
	ORDER BY DepartmentID

--Task 14 Employees Minimum Salaries

SELECT
	DepartmentID,
	MIN(Salary) AS MinimumSalary
	FROM Employees
	WHERE DepartmentID IN(2, 5, 7) AND HireDate > '2000-01-01'
	GROUP BY DepartmentID
	ORDER BY DepartmentID

--Task 15 Employees Average Salaries

SELECT *
	INTO NewT
	FROM Employees
	WHERE Salary > 3000

DELETE FROM NewT
WHERE ManagerID = 42

UPDATE NewT
SET Salary += 5000
WHERE DepartmentID = 1

SELECT
	DepartmentID,
	AVG(Salary) AS AverageSalary
	FROM NewT
	GROUP BY DepartmentID

--Task 16 Employee Maximum Salaries

SELECT
	DepartmentID,
	MAX(Salary) AS MaxSalary
	FROM Employees
	GROUP BY DepartmentID
	HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--Task 17 Employees Count Salaries

SELECT
	COUNT(*) AS Count
	FROM Employees
	WHERE ManagerID IS NULL


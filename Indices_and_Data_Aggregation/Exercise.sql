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

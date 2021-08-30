USE AdventureWorks2008R2;

WITH Accountorders
AS (
	SELECT SUM(TotalDue) AS TotalSum ,
		   YEAR(OrderDate) AS Year,
		   MONTH(OrderDate) AS Month,
		   DAY(OrderDate) AS 'Date'
	FROM Sales.SalesOrderHeader AS soh
	GROUP BY AccountNumber, OrderDate
)
SELECT TOP 5 * FROM Accountorders
	WHERE TotalSum > 7000
	ORDER BY Year DESC, Month DESC;
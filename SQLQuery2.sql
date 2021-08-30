--Using JOIN:
SELECT *
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
WHERE s.SalesOrderID IS NULL;

--Using CTE:
WITH s AS
(   SELECT SalesOrderID
    FROM Sales.SalesOrderHeader
)
SELECT *
FROM Sales.Customer c
LEFT OUTER JOIN s ON c.CustomerID = s.SalesOrderID
WHERE s.SalesOrderID IS NULL

--Using SubQuery:
SELECT *
FROM Sales.Customer c
where c.CustomerID in(
SELECT s.CustomerID
FROM Sales.SalesOrderHeader s
WHERE s.SalesOrderID IS NULL)

--Using EXISTS:
SELECT *
FROM Sales.Customer c
where EXISTS(
SELECT *
FROM Sales.SalesOrderHeader s
WHERE s.SalesOrderID IS NULL
AND c.customerID = s.customerID)
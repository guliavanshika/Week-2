# Week-2
ASSIGNMENT – 2 
SQL COMMANDS 
Q1. The exercise requires SQL Server AdventureWorks OLTP database which can be found at Codeplex. Download and attach a copy of the database to your server instance. Take some time to appreciate the entire schema of the database, and functions and stored procedures (refer AdventureWorks 2008 OLTP Schema.pdf). Using the AdventureWorks database, perform the following queries.
1. Display the number of records in the [SalesPerson] table. (Schema(s) involved: Sales)
SELECT count( * ) as  total_record FROM Sales.SalesPerson;

2. Select both the FirstName and LastName of records from the Person table where the FirstName begins with the letter ‘B’. (Schema(s) involved: Person)
SELECT FirstName , LastName from Person.Person where FirstName like 'B%';

3. Select a list of FirstName and LastName for employees where Title is one of Design Engineer, Tool Designer or Marketing Assistant. (Schema(s) involved: HumanResources, Person)
SELECT P.FirstName, P.LastName, H.Name 
 FROM Person.Person P
 		 JOIN HumanResources.Department H
     		 ON H.Name = 'Tool Design'Or 
		 H.Name = 'Marketing' Or 
		 H.Name = 'Engineering';

4. Display the Name and Color of the Product with the maximum weight. (Schema(s) involved: Production)
SELECT  Name, Color, Weight From Production.Product 
where Weight >= (select max(Weight) from Production.Product);

5. Display Description and MaxQty fields from the SpecialOffer table. Some of the MaxQty values are NULL, in this case display the value 0.00 instead. (Schema(s) involved: Sales)
SELECT Description, ISNULL(MaxQty,0.0) from Sales.SpecialOffer ;

6. Display the overall Average of the [CurrencyRate].[AverageRate] values for the exchange rate ‘USD’ to ‘GBP’ for the year 2005 i.e. FromCurrencyCode = ‘USD’ and ToCurrencyCode = ‘GBP’. Note: The field [CurrencyRate].[AverageRate] is defined as 'Average exchange rate for the day.' (Schema(s) involved: Sales)
SELECT AVG(EndOfDayRate) as 'Average_exchange_rate_for_the_day' 
from Sales.CurrencyRate 
		where FromCurrencyCode = 'USD' 
		and ToCurrencyCode = 'GBP'
		and YEAR((CurrencyRateDate)) = 2005;

7. Display the FirstName and LastName of records from the Person table where FirstName contains the letters ‘ss’. Display an additional column with sequential numbers for each row returned beginning at integer 1. (Schema(s) involved: Person)
SELECT ROW_NUMBER() OVER (ORDER BY FirstName ASC) 
AS SerialNo, FirstName, LastName 
		from Person.Person 
		where FirstName like '%ss%' ;

8. Sales people receive various commission rates that belong to 1 of 4 bands. (Schema(s) involved: Sales)
CommissionPct Commission Band
0.00 Band 0
Up To 1% Band 1
Up To 1.5% Band 2
Greater 1.5% Band 3
Display the [SalesPersonID] with an additional column entitled ‘Commission Band’ indicating the appropriate band as above.
	SELECT BusinessEntityID, CommissionPct,
'CommissionBand' = CASE
		when CommissionPct = 0 then 'Band 0'
		when CommissionPct > 0 and CommissionPct <= 0.01 then 'Band 1'
		when CommissionPct > 0.01 and CommissionPct <= 0.015 then 'Band 2'
		when CommissionPct > 0.015 then 'Band 3'
	END
		from Sales.SalesPerson
		Order By CommissionPct;
9. Display the managerial hierarchy from Ruth Ellerbrock (person type – EM) up to CEO Ken Sanchez. Hint: use [uspGetEmployeeManagers] (Schema(s) involved: [Person], [HumanResources]) 
DECLARE @EmployeeID int = (
	SELECT Person.Person.BusinessEntityID FROM Person.Person 
	WHERE FirstName = 'Ruth' AND LastName = 'Ellerbrock' AND PersonType ='EM' ) ;
EXEC dbo.uspGetEmployeeManagers @BusinessEntityID = @EmployeeID;

10. Display the ProductId of the product with the largest stock level. Hint: Use the Scalar-valued function [dbo]. [UfnGetStock]. (Schema(s) involved: Production)

Select DISTINCT ProductID  from Production.ProductInventory where LocationID=6 
	SELECT dbo.ufnGetStock(326)
	declare @result int
	set @result = dbo.ufnGetStock(326)
	select @result as 'Result'


Q2. Write separate queries using a join, a subquery, a CTE, and then an EXISTS to list all AdventureWorks customers who have not placed an order.
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

Q3. Show the most recent five orders that were purchased from account numbers that have spent more than $70,000 with AdventureWorks.
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





Q4. Create a function that takes as inputs a SalesOrderID, a Currency Code, and a date, and returns a table of all the SalesOrderDetail rows for that Sales Order including Quantity, ProductID, UnitPrice, and the unit price converted to the target currency based on the end of day rate for the date provided. Exchange rates can be found in the Sales.CurrencyRate table. (Use AdventureWorks)
CREATE FUNCTION NewUnitPrice (
	@salesOrderId int,
	@currencyCode nvarchar(20),
	@date date
)
RETURNS TABLE
AS 
RETURN (
	 SELECT OrderQty , ProductID, Unitprice *
	 ( SELECT EndOfdayRate 
	 FROM Sales.CurrencyRate
	 WHERE ModifiedDate = @date AND
	 ToCurrencyCode = @currencyCode )
	 AS UnitPrice
	 FROM Sales.SalesOrderDetail
	 WHERE SalesOrderID = @salesOrderId
)
GO 
SELECT * FROM NewUnitPrice (43659,'AUD','2005-07-01');

Q5. Write a Procedure supplying name information from the Person.Person table and accepting a filter for the first name. Alter the above Store Procedure to supply Default Values if user does not enter any value. ( Use AdventureWorks)
CREATE PROCEDURE usGetPersonFilterName
@name nvarchar(50)
AS 
BEGIN
	IF (@name = '') BEGIN 
		SELECT * FROM Person.Person ORDER BY FirstName;
	END 
	ELSE BEGIN
		SELECT * FROM Person.Person where FirstName = @name ORDER BY FirstName;
	END 
END 
-- by name 
DECLARE @First nvarchar(50)
set @First = 'Aaron'
execute usGetPersonFilterName @First
GO
--default 
DECLARE @FirstName nvarchar(50)
set @FirstName=''
execute usGetPersonFilterName @FirstName


Q6. Write a trigger for the Product table to ensure the list price can never be raised more than 15 Percent in a single change. Modify the above trigger to execute its check code only if the ListPrice column is updated (Use AdventureWorks Database)
ALTER TRIGGER [Production].[trgLimitPriceChanges]
	ON [Production].[Product] FOR UPDATE
	AS
IF UPDATE(ListPrice)
	BEGIN
	IF EXISTS (
	SELECT * FROM inserted i
	JOIN deleted d ON i.ProductID = d.ProductID
	WHERE i.ListPrice > (d.ListPrice * 1.15) )
	BEGIN RAISERROR('Price increase may not be greater than 15 percent.Transaction Failed.',16,1)
	ROLLBACK TRAN
	END
END
GO

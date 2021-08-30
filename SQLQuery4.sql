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
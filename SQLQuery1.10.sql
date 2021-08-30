

Select DISTINCT ProductID  from Production.ProductInventory where LocationID = 6 

	SELECT dbo.ufnGetStock(326)

	declare @result int
	set @result = dbo.ufnGetStock(326)
	select @result as 'Result'


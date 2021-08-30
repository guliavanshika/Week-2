SELECT BusinessEntityID, CommissionPct,
	'CommissionBand' = CASE
	when CommissionPct = 0 then 'Band 0'
	when CommissionPct > 0 and CommissionPct <= 0.01 then 'Band 1'
	when CommissionPct > 0.01 and CommissionPct <= 0.015 then 'Band 2'
	when CommissionPct > 0.015 then 'Band 3'
	END
	from Sales.SalesPerson
	Order By CommissionPct;
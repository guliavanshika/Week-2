SELECT AVG(EndOfDayRate) as 'Average_exchange_rate_for_the_day' from Sales.CurrencyRate 
	where FromCurrencyCode = 'USD' 
	and ToCurrencyCode = 'GBP'
	and YEAR((CurrencyRateDate)) = 2005;

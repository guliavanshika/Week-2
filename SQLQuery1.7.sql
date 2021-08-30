SELECT ROW_NUMBER() OVER (ORDER BY FirstName ASC) AS SerialNo, FirstName, LastName 
	from Person.Person 
	where FirstName like '%ss%' ;

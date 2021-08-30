DECLARE @EmployeeID int = (
	SELECT Person.Person.BusinessEntityID FROM Person.Person 
	WHERE FirstName = 'Ruth' AND LastName = 'Ellerbrock' AND PersonType ='EM' ) ;
EXEC dbo.uspGetEmployeeManagers @BusinessEntityID = @EmployeeID;

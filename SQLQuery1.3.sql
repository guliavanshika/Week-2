SELECT P.FirstName, P.LastName, H.Name 
 FROM Person.Person P
   JOIN HumanResources.Department H
     ON H.Name = 'Tool Design'Or 
	 H.Name = 'Marketing' Or 
	 H.Name = 'Engineering';

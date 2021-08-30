ALTER TRIGGER [Production].[trgLimitPriceChanges]
	ON [Production].[Product]
	FOR UPDATE
	AS
IF UPDATE(ListPrice)
	BEGIN
		IF EXISTS (
		SELECT *
		FROM inserted i
		JOIN deleted d
		ON i.ProductID = d.ProductID
		WHERE i.ListPrice > (d.ListPrice * 1.15) )
		BEGIN RAISERROR('Price increase may not be greater than 15 percent.Transaction Failed.',16,1)
		ROLLBACK TRAN
		END
	END
GO
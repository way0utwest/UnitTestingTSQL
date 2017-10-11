/*
Null tests

*/

-- We have a function designed to find a value in a table.
CREATE FUNCTION GetCustomerSalesOrderDetail (@SalesOrderDetailID INT)
RETURNS INT
AS
BEGIN
    DECLARE @productID INT;
    SELECT @productID = ProductID
    FROM dbo.SalesOrderDetail
    WHERE SalesOrderDetailID = @SalesOrderDetailID;
    RETURN @productID;
END;
GO
SELECT dbo.GetProductIdForSalesOrderDetail(2);


-- We now need a test for this to ensure this works
-- New test class and test for this
EXEC tsqlt.NewTestClass @ClassName = N'tSalesOrderTests' -- nvarchar(max)
GO
CREATE PROCEDURE [tSalesOrderTests].[test the correct product returns for a valid salesorderid]
AS
BEGIN
    --------------------------------------------
	----- Assemble
	--------------------------------------------
	EXEC tsqlt.FakeTable @TableName = N'SalesOrderDetail'

	INSERT dbo.SalesOrderDetail
	(
	    SalesOrderDetailID,
	    ProductID
	)
	VALUES
	(1, 100), (2, 200), (3, 300)

    DECLARE @expected INT = 200,
	        @actual INT

    --------------------------------------------
	----- Act
	--------------------------------------------
	SELECT @actual = dbo.GetProductIdForSalesOrderDetail(2)

    --------------------------------------------
	----- Assert
	--------------------------------------------
	EXEC tsqlt.AssertEquals @Expected = @expected, -- sql_variant
	                        @Actual = @actual,   -- sql_variant
	                        @Message = N'Incorrect product ID returned'    -- nvarchar(max)

END    
GO


-- Test the test
EXEC tsqlt.run '[tSalesOrderTests].[test the correct product returns for a valid salesorderid]';



-- This works.
-- We could introduce an error in the test or code to check, but this is fine.

-- We later have an issue in the application. This code is being run.
-- It returns a NULL but we should never return a NULL
SELECT dbo.GetProductIdForSalesOrderDetail(44);
GO

-- There are programmatic ways to handle this in the function, but we should
-- ensure that this doesn't happen in the future if the function is changed
-- by adding a test that checks for null returns.
-- This also documents the requirement that nulls not be returned


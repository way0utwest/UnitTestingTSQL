/*
Testing T-SQL Made Easy - Isolating Functions and Procedures

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

USE [TestingTSQL]
GO
-- let's test our existing code
EXEC tsqlt.run '[LocalTaxForOrderTests]'
GO



-- change the procedure
-- we want a complete recalculation in case of a change
ALTER PROCEDURE dbo.SetLocalTaxRate
  @OrderId INT
AS
BEGIN
  UPDATE O 
  SET
         o.TaxAmount = (o.OrderQuantity * o.UnitPrice) * dbo.CalcSalesTaxForSale(O.ShippingState,o.OrderQuantity * o.UnitPrice)
         -- old code
         -- o.TaxAmount = o.LineTotal * dbo.CalcSalesTaxForSale(O.ShippingState,O.LineTotal)
    FROM dbo.SalesOrderDetail AS O
   WHERE O.SalesOrderDetailID = @OrderId;    
END;
GO



-- retest
EXEC tsqlt.run '[LocalTaxForOrderTests]'
GO




-- Failure
--  Why?

-- We have changed the logic of the calculation.
-- Which is right?
-- We should stop and verify here. Check that we want to use the correct value.

-- If the calculation should be on line item, let's change our update back.
-- If the calculation should be on all values, we need to alter the test



-- If the calculation is correct, change the test
ALTER PROCEDURE [LocalTaxForOrderTests].[test dbo.SetLocalTaxRate updates correctly using dbo.CalcSalesTaxForSale]
AS
BEGIN
  --Assemble
  EXEC tSQLt.FakeTable @TableName = 'dbo.SalesOrderDetail';
  EXEC tSQLt.FakeFunction 
       @FunctionName = 'dbo.CalcSalesTaxForSale', 
       @FakeFunctionName = 'LocalTaxForOrderTests.[0.2 sales tax]';

  INSERT INTO dbo.SalesOrderDetail(SalesOrderDetailID,LineTotal,ShippingState, OrderQuantity, UnitPrice)
  VALUES(42,100,'PA', 5, 20);

  --Act
  EXEC dbo.SetLocalTaxRate @OrderId = 42;

  --Assert
  SELECT O.SalesOrderDetailID,O.TaxAmount
  INTO #Actual
  FROM dbo.SalesOrderDetail AS O;
  
  SELECT TOP(0) *
  INTO #Expected
  FROM #Actual;
  
  INSERT INTO #Expected
  VALUES(42,20);

  EXEC tSQLt.AssertEqualsTable '#Expected','#Actual';
END;
GO


-- Retest
EXEC tsqlt.run '[LocalTaxForOrderTests]'
GO


/*******************************************************************************
*                                                                              *
*                            END DEMO                                          *
*                                                                              *
********************************************************************************/
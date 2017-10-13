/*
Testing T-SQL Made Easy - Tests can find potential holes in requirements

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

USE [TestingTSQL]
GO

-- We have a function for discounts, UF_CalcDiscountForSale
-- Right now we have discounts of 5% and 10% based on quantity. 
-- However no one has every bought qty > 100.
-- management wants to boost sales with new discounts. The rules are:
--    Qty more than 20 and less than 50 = 5%
--    Qty more than 50 = 7.5%
--    Qty more than 100 = 10%



-- examine the function.
SELECT dbo.UF_CalcDiscountForSale(2);
SELECT dbo.UF_CalcDiscountForSale(22);
go





-- The code wasn't well written, but we see that. Let's write some tests.
-- New test class
EXEC tsqlt.NewTestClass
  @ClassName = N'tSalesOrderDetail';
  GO





-- we could do this. Look at these 3 tests.
CREATE PROCEDURE [tSalesOrderDetail].[test Check Discount Calculation for qty 19 = 0%]
AS
    BEGIN
  -- Assemble
        DECLARE @expected NUMERIC(10 ,3) = 0.00
          , @actual NUMERIC(10 ,3);

  -- act
        SELECT  @actual = dbo.UF_CalcDiscountForSale(19);
  -- assert    
        EXEC tSQLt.AssertEquals @Expected = @expected ,@Actual = @actual ,
            @Message = N'An incorrect discount calculation occurred.';
  
    END;
GO

CREATE PROCEDURE [tSalesOrderDetail].[test Check Discount Calculation for qty 20 = 5%]
AS
    BEGIN
  -- Assemble
        DECLARE @expected NUMERIC(10 ,3) = 0.05
          , @actual NUMERIC(10 ,3);

  -- act
        SELECT  @actual = dbo.UF_CalcDiscountForSale(20);
  -- assert    
        EXEC tSQLt.AssertEquals @Expected = @expected ,@Actual = @actual ,
            @Message = N'An incorrect discount calculation occurred.'
  
    END
GO

CREATE PROCEDURE [tSalesOrderDetail].[test Check Discount Calculation for qty 50 = 7.5%]
AS
    BEGIN
  -- Assemble
        DECLARE @expected NUMERIC(10 ,3) = 0.075
          , @actual NUMERIC(10 ,3);

  -- act
        SELECT  @actual = dbo.UF_CalcDiscountForSale(50);
  -- assert    
        EXEC tSQLt.AssertEquals @Expected = @expected ,@Actual = @actual ,
            @Message = N'An incorrect discount calculation occurred.'
  
    END
GO




-- We could continue to write other tests for different values and boudaries.
-- However that's confusing and it results in a lot of tests for simple rules. 







-- Let's simplify.
CREATE OR ALTER PROCEDURE [tSalesOrderDetail].[test Check Discount Calculation for qty rules]
AS
    BEGIN
  -- Assemble
  CREATE table #expected (qty INT, discount NUMERIC(10 ,3));

-- SQL Prompt formatting off
  INSERT #expected
          ( qty ,discount )
  VALUES  ( 19 ,0.0 )
        , ( 20 ,0.05 )
        , ( 49 ,0.05 )
        , ( 50 ,0.05 )
        , ( 99 ,0.075 )
        , ( 100 ,0.1 )
-- SQL Prompt formatting on

  SELECT TOP(0) *
   INTO #actual
   FROM #expected

  -- act
  INSERT #actual SELECT 19, dbo.UF_CalcDiscountForSale(19);
  INSERT #actual SELECT 20, dbo.UF_CalcDiscountForSale(20);
  INSERT #actual SELECT 49, dbo.UF_CalcDiscountForSale(49);
  INSERT #actual SELECT 50, dbo.UF_CalcDiscountForSale(50);
  INSERT #actual SELECT 99, dbo.UF_CalcDiscountForSale(99);
  INSERT #actual SELECT 100, dbo.UF_CalcDiscountForSale(100);

 -- assert    
        EXEC tSQLt.AssertEqualsTable @Expected = N'#expected' ,@Actual = N'#actual' ,@FailMsg = N'The discount calculations are incorrect'
  
    END
GO


EXEC tsqlt.run '[tSalesOrderDetail].[test Check Discount Calculation for qty rules]';
GO






-- Let's refactor the procedure
-- Set the boundaries carefully
-- look at results
IF OBJECT_ID('dbo.UF_CalcDiscountForSale') IS NOT NULL
    DROP FUNCTION dbo.UF_CalcDiscountForSale;
GO
CREATE FUNCTION dbo.UF_CalcDiscountForSale ( @QtyPurchased INT )
RETURNS NUMERIC(10 ,3)
/*
-- Test Code
select dbo.UF_CalcDiscountForSale(10);
select dbo.UF_CalcDiscountForSale(25);
select dbo.UF_CalcDiscountForSale(125);
*/
AS
    BEGIN
        DECLARE @i NUMERIC(10,3);

        SELECT  @i = CASE WHEN ( @QtyPurchased >= 100 ) THEN 0.1
                          WHEN ( @QtyPurchased >= 50 ) AND (@QtyPurchased < 100)
                               THEN 0.075
                          WHEN ( @QtyPurchased >= 20 ) AND (@QtyPurchased < 50)
                               THEN 0.05
                          ELSE 0.0
                     END

        RETURN @i
    END

GO


-- retest
EXEC tsqlt.run '[tSalesOrderDetail].[test Check Discount Calculation for qty rules]';
GO


ALTER FUNCTION dbo.UF_CalcDiscountForSale ( @QtyPurchased INT )
RETURNS NUMERIC(10 ,3)
/*
-- Test Code
select dbo.UF_CalcDiscountForSale(10);
select dbo.UF_CalcDiscountForSale(25);
select dbo.UF_CalcDiscountForSale(125);
*/
AS
    BEGIN
        DECLARE @i NUMERIC(10,3);

        SELECT  @i = CASE WHEN ( @QtyPurchased >= 100 ) THEN 0.1
                          WHEN ( @QtyPurchased > 50 ) AND (@QtyPurchased < 100)
                               THEN 0.075
                          WHEN ( @QtyPurchased >= 20 ) AND (@QtyPurchased <= 50)
                               THEN 0.05
                          ELSE 0.0
                     END

        RETURN @i
    END

GO


-- retest
EXEC tsqlt.run '[tSalesOrderDetail].[test Check Discount Calculation for qty rules]';
GO

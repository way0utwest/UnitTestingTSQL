CREATE OR ALTER PROCEDURE $TestSchema.[test $TestName]
AS
BEGIN
    ---------------
    -- Assemble
    ---------------
    DECLARE
        @expected int,
        @actual   int;

	--EXEC tsqlt.faketable @TableName = 'MyTable', @SchemaName = 'dbo';
	--INSERT MyTable ()
	-- VALUES ()
	--      , ()


 --   CREATE TABLE #Expected
	--( MyID INT
	--)
	--INSERT #Expected (MyID) 
	--VALUES (0)

	--SELECT TOP 0
	--INTO #Actual
	--FROM #Expected

    ---------------
    -- Act
    ---------------
    SELECT @actual = dbo.UF_CalcDiscountForSale(50);

    ---------------
    -- Assert    
    ---------------
    EXEC tSQLt.AssertEquals
        @Expected = @expected,
        @Actual = @actual,
        @Message = N'An incorrect discount calculation occurred.';
END;
GO

/*
Testing T-SQL Made Easy - SQL Cop Setup

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- change the database
USE TestingTSQL;
GO
EXEC tsqlt.NewTestClass
  @ClassName = N'SQLCop' -- nvarchar(max)
GO
-- create stubs
IF NOT EXISTS( SELECT name FROM sys.objects WHERE name = 'test Procedures Named SP_')
  EXEC('create procedure [SQLCop].[test Procedures Named SP_] as begin select 1 end')
IF NOT EXISTS( SELECT name FROM sys.objects WHERE name = 'test Procedures with @@Identity')
  EXEC('create procedure [SQLCop].[test Procedures with @@Identity] as begin select 1 end')
IF NOT EXISTS( SELECT name FROM sys.objects WHERE name = 'test Tables without a primary key')
  EXEC('create procedure [SQLCop].[test Tables without a primary key] as begin select 1 end')
IF NOT EXISTS( SELECT name FROM sys.objects WHERE name = 'test prevent tbl Table prefix')
  EXEC('create procedure [SQLCop].[test prevent tbl Table prefix] as begin select 1 end')

-- Include some SQLCop tests
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [SQLCop].[test Procedures Named SP_]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012
    -- http://sqlcop.lessthandot.com
    -- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/MSSQLServer/don-t-start-your-procedures-with-sp_
    
    SET NOCOUNT ON
    
-- Act  
    SELECT	'Stored Procedure Name' = s.name + '.' + o.name
	INTO #actual
    From	sys.objects o
            INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
            LEFT OUTER JOIN sys.extended_properties e ON o.object_id = e.major_id
                                                              AND e.class_desc = 'OBJECT_OR_COLUMN'
                                                              AND e.name = 'sp_Exception'
    Where	o.type = 'P'
            AND s.name <> 'tsqlt'
			AND o.name COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI LIKE 'sp[_]%'
            And o.name COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI NOT LIKE '%diagram%'
            AND (e.value != 1 OR e.value IS NULL)
    Order By s.name, o.name

    EXEC tsqlt.AssertEmptyTable
      @TableName = N'#actual'
    , -- nvarchar(max)
      @Message = N'There are stored procedures named sp_' -- nvarchar(max)
    
END;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [SQLCop].[test Procedures with @@Identity]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://wiki.lessthandot.com/index.php/6_Different_Ways_To_Get_The_Current_Identity_Value
	
	SET NOCOUNT ON

	Declare @Output VarChar(max)
	Set @Output = ''

	Select	@Output = @Output + Schema_Name(schema_id) + '.' + name + Char(13) + Char(10)
	From	sys.all_objects
	Where	type = 'P'
			AND name Not In('sp_helpdiagrams','sp_upgraddiagrams','sp_creatediagram','testProcedures with @@Identity')
			And Object_Definition(object_id) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%@@identity%'
			And is_ms_shipped = 0
			and schema_id <> Schema_id('tSQLt')
			and schema_id <> Schema_id('SQLCop')
	ORDER BY Schema_Name(schema_id), name 

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://wiki.lessthandot.com/index.php/6_Different_Ways_To_Get_The_Current_Identity_Value'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
	
END;

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [SQLCop].[test Tables without a primary key]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/best-practice-every-table-should-have-a
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + su.name + '.' + AllTables.Name + Char(13) + Char(10)
	FROM	(
			SELECT	Name, id, uid
			From	sysobjects
			WHERE	xtype = 'U'
			) AS AllTables
			INNER JOIN sysusers su
				On AllTables.uid = su.uid
			LEFT JOIN (
				SELECT parent_obj
				From sysobjects
				WHERE  xtype = 'PK'
				) AS PrimaryKeys
				ON AllTables.id = PrimaryKeys.parent_obj
	WHERE	PrimaryKeys.parent_obj Is Null
			AND su.name <> 'tSQLt'
	ORDER BY su.name,AllTables.Name

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/best-practice-every-table-should-have-a' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	
END;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [SQLCop].[test prevent tbl Table prefix]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/MSSQLServer/don-t-prefix-your-table-names-with-tbl/
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + TABLE_SCHEMA + '.' + TABLE_NAME + Char(13) + Char(10)
	From	Information_Schema.tables 
    WHERE	Table_Type = 'Base Table'
       	And Table_Name Like 'tbl%'

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/MSSQLServer/don-t-prefix-your-table-names-with-tbl/' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	
END;
GO


EXEC tSQLt.NewTestClass 'LocalTaxForOrderTests';
GO
CREATE FUNCTION LocalTaxForOrderTests.[0.2 sales tax] (
   @state CHAR(2),
   @amount NUMERIC(12, 3)
)
RETURNS NUMERIC(12, 3)
AS
BEGIN
  RETURN 0.2;
END;
GO
CREATE PROCEDURE LocalTaxForOrderTests.[test dbo.SetLocalTaxRate updates correctly using dbo.CalcSalesTaxForSale]
AS
BEGIN
  --Assemble
  EXEC tSQLt.FakeTable @TableName = 'dbo.SalesOrderDetail';
  EXEC tSQLt.FakeFunction 
       @FunctionName = 'dbo.CalcSalesTaxForSale', 
       @FakeFunctionName = 'LocalTaxForOrderTests.[0.2 sales tax]';

  INSERT INTO dbo.SalesOrderDetail(SalesOrderDetailID,LineTotal,ShippingState)
  VALUES(42,100,'PA');

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

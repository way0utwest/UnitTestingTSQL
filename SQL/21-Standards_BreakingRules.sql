/*
Testing T-SQL Made Easy

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- Standards
USE [TestingTSQL]
GO

-- First, test
-- check our database for current quality
EXEC tsqlt.run '[SQLCop]';
go




-- add a proc
CREATE PROCEDURE sp_test AS SELECT 1
GO

EXEC tsqlt.RunTestClass @TestClassName = N'SQLCOP' -- nvarchar(max)
GO

EXEC sp_rename 'sp_test', 'spTest'

GO
EXEC tsqlt.RunTestClass @TestClassName = N'SQLCOP' -- nvarchar(max)
GO









-- check our database for current quality
EXEC tsqlt.run '[SQLCop]';
go















-- let's build a new table.
CREATE TABLE [dbo].[ContentItems_Staging]
(
[ContentItemID] [int] NOT NULL IDENTITY(1, 1),
[PrimaryTagID] [int] NULL,
[Title] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShortTitle] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (3500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Text] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalURL] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublishingStatus] [int] NOT NULL,
[SourceID] [int] NULL,
[ForumThreadID] [int] NULL,
[UpdatesContentItemID] [int] NULL,
[EstimateofReadingTime] [time] NOT NULL
)
GO






-- Now we re-run our standards tests.
-- We only want to run the minimal test here. We'll add more later.
EXEC tsqlt.run '[SQLCop]'
GO



-- We have a failure.
-- This a test ensuring we always have a PK.







-- However, we don't want a primary key here. This is a staging table that we want to load
-- as quickly as possible.
-- Let's add an exception.

EXEC sys.sp_addextendedproperty 
  @name = 'PKException',
  @value = 1, -- sql_variant
  @level0type = 'schema', -- varchar(128)
  @level0name = 'dbo', -- sysname
  @level1type = 'table', -- varchar(128)
  @level1name = 'ContentItems_Staging' -- sysname
  ;
GO






-- Alter the test to allow the exception
ALTER PROCEDURE [SQLCop].[test Tables without a primary key]
AS
BEGIN

-- Assemble
DECLARE @output nvarchar(max)

-- act
SELECT AllTables.name
 INTO #actual
  FROM    ( SELECT    o.name ,
                    o.object_id AS id ,
                    COALESCE( e. value, 0) AS 'PKException'
          FROM      sys.objects o
                    INNER JOIN sys.schemas s ON s. schema_id = o.schema_id
----------------------------------
---- New Code --------------------
----------------------------------
                    LEFT OUTER JOIN sys.extended_properties e ON o.object_id = e .major_id
                                                              AND e.value = 1
                                                              AND e.class_desc = 'OBJECT_OR_COLUMN'
                                                              AND e.name = 'PKException'
----------------------------------
---- New Code --------------------
----------------------------------
          WHERE     o.type = 'U'
                    AND s.name <> 'tsqlt'
        ) AS AllTables
        LEFT JOIN ( SELECT  parent_object_id
                    FROM    sys.objects
                    WHERE   type = 'PK'
                  ) AS PrimaryKeys ON AllTables.id = PrimaryKeys.parent_object_id
WHERE    PrimaryKeys.parent_object_id IS NULL
        AND AllTables.PKException = 0
ORDER BY AllTables.name;

-- assert
EXEC tsqlt.AssertEmptyTable @TableName = N'#actual', -- nvarchar(max)
  @Message = N'There are tables without a primary key.' -- nvarchar(max)
END


GO







-- now re-test
EXEC tsqlt.run '[SQLCop]'
GO




-- If we change our mind....
EXEC sys.sp_updateextendedproperty
  @name = 'PKException'
, @value = 0
, @level0type = 'schema'
, @level0name = 'dbo'
, @level1type = 'table'
, @level1name = 'ContentItems_Staging' -- sysname
  ;
GO





-- now re-test
EXEC tsqlt.run '[SQLCop]'
GO




-- fix
EXEC sys.sp_updateextendedproperty
  @name = 'PKException'
, @value = 1
, @level0type = 'schema'
, @level0name = 'dbo'
, @level1type = 'table'
, @level1name = 'ContentItems_Staging' -- sysname
  ;
GO



-- drop table [SalesHeader_Staging]













-- test
EXEC tsqlt.run '[SQLCop]';
GO




-- fix
EXEC sys.sp_rename
  @objname = N'sp_test'
, -- nvarchar(1035)
  @newname = 'prcTest';
GO







-- test
EXEC tsqlt.run '[SQLCop]';
GO








--break
EXEC sys.sp_rename
  @objname = N'prctest'
, -- nvarchar(1035)
  @newname = 'sp_Test';
GO









-- test
EXEC tsqlt.run '[SQLCop]';
GO











-- allow an exclusion
EXEC sys.sp_addextendedproperty
  @name = 'sp_Exception'
, -- sysname
  @value = 1
, -- sql_variant
  @level0type = 'schema'
, -- varchar(128)
  @level0name = 'dbo'
, -- sysname
  @level1type = 'procedure'
, -- varchar(128)
  @level1name = 'sp_Test'
;
GO



-- test
EXEC tsqlt.run '[SQLCop]';
GO


/*******************************************************************************
*                                                                              *
*                            END DEMO                                          *
*                                                                              *
********************************************************************************/

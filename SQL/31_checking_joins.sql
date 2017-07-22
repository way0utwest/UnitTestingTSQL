/*
Unit Testing T-SQL - Checking Joins

Steve Jones, copyright 2017

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- We want to alter a table.
USE [TestingTSQL]
GO
EXEC dbo.GetArticleHeadlines
GO




-- We have a test
-- this returns current headlines.
EXEC tsqlt.NewTestClass
  @ClassName = N'tContentTests';
GO
CREATE PROCEDURE [tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]
-- ALTER PROCEDURE [tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]
AS
BEGIN
---------------
-- Assemble
---------------

-- Empty a data table and fill with known test data
EXEC tsqlt.FakeTable
  @TableName = N'ContentItems'
, @SchemaName = N'dbo';
INSERT dbo.ContentItems ( ContentItemID, Title, ExternalURL)
 VALUES (1, 'Test 1', 'http://someurl.com/1/')
      , (2, 'Test 2', 'http://someurl.com/2/')
      , (3, 'Test 3', 'http://someurl.com/3/')
      , (4, 'Test 4', 'http://someurl.com/4/')
      , (5, 'Test 5', 'http://someurl.com/5/')
      , (6, 'Test 6', 'http://someurl.com/6/')
      , (7, 'Test 7', 'http://someurl.com/7/')
      , (8, 'Test 8', 'http://someurl.com/8/')
      , (9, 'Test 9', 'http://someurl.com/9/')
      , (10, 'Test 10', 'http://someurl.com/10/')
      , (11, 'Test 11', 'http://someurl.com/11/');

-- Create a table with the expected results
CREATE TABLE #expected 
( ContentItemID INT
, Title VARCHAR(200)
, ExternalURL VARCHAR(250)
)
INSERT #expected
 VALUES
 ( 1, 'Test 1', 'http://someurl.com/1/')
,( 2, 'Test 2', 'http://someurl.com/2/')
,( 3, 'Test 3', 'http://someurl.com/3/')
,( 4, 'Test 4', 'http://someurl.com/4/')
,( 5, 'Test 5', 'http://someurl.com/5/')

-- Create a table to hold the actual code results
SELECT *
 INTO #actual
  FROM #expected AS e
  WHERE 1 = 0

---------------
-- Act
---------------
INSERT #actual 
EXEC dbo.GetArticleHeadlines;

---------------
-- Assert
---------------
EXEC tsqlt.AssertEqualsTable
  @Expected = N'#expected'
, @Actual = N'#actual'
, @FailMsg = N'Incorrect headlines returned';

END
GO
--
-- END TEST
-- 




-- test
EXEC tsqlt.run '[tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]';
GO








-- Let's refactor:
ALTER PROCEDURE dbo.GetArticleHeadlines
AS
BEGIN
SELECT TOP 5
    ci.ContentItemID
   ,ci.Title
   ,ci.ExternalURL
  , cpr.AverageRating AS 'AverageRating'
   , cpr.ViewsLastNDays AS 'ViewsLastNDays'
   , cpr.TotalViews AS 'TotalViews'
  FROM
    dbo.ContentItems AS ci
  INNER JOIN dbo.ContentPerformanceRecord AS cpr
  ON
    cpr.ContentItemID = ci.ContentItemID; 
END
go


-- Refactor the test
ALTER PROCEDURE [tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]
AS
BEGIN
-- assemble
EXEC tsqlt.FakeTable
  @TableName = N'ContentItems'
, @SchemaName = N'dbo';
INSERT dbo.ContentItems ( ContentItemID, Title, ExternalURL)
 VALUES (1, 'Test 1', 'http://someurl.com/1/')
      , (2, 'Test 2', 'http://someurl.com/2/')
      , (3, 'Test 3', 'http://someurl.com/3/')
      , (4, 'Test 4', 'http://someurl.com/4/')
      , (5, 'Test 5', 'http://someurl.com/5/')
      , (6, 'Test 6', 'http://someurl.com/6/')
      , (7, 'Test 7', 'http://someurl.com/7/')
      , (8, 'Test 8', 'http://someurl.com/8/')
      , (9, 'Test 9', 'http://someurl.com/9/')
      , (10, 'Test 10', 'http://someurl.com/10/')
      , (11, 'Test 11', 'http://someurl.com/11/');

EXEC tsqlt.FakeTable
  @TableName = N'ContentPerformanceRecord'
, @SchemaName = N'dbo';

INSERT dbo.ContentPerformanceRecord (ContentItemID, AverageRating, ViewsLastNDays, TotalViews)
 VALUES
 (1, 4.0, 10, 20 )
,(2, 5.2, 20, 40 )
,(3, 6.5, 40, 80 )

CREATE TABLE #expected 
( ContentItemID INT
, Title VARCHAR(200)
, ExternalURL VARCHAR(250)
, AverageRating NUMERIC(18, 4)
, ViewsLastNDays INT
, TotalViews int
)
INSERT #expected
 VALUES
 ( 1, 'Test 1', 'http://someurl.com/1/', 4.0, 10, 20 )
,( 2, 'Test 2', 'http://someurl.com/2/', 5.2, 20, 40 )
,( 3, 'Test 3', 'http://someurl.com/3/', 6.5, 40, 80 )
,( 4, 'Test 4', 'http://someurl.com/4/', 0.0, 0.0, 0 )
,( 5, 'Test 5', 'http://someurl.com/5/', 0.0, 0.0, 0 )

SELECT *
 INTO #actual
  FROM #expected AS e
  WHERE 1 = 0

-- act
INSERT #actual 
EXEC dbo.GetArticleHeadlines;

-- assert
EXEC tsqlt.AssertEqualsTable
  @Expected = N'#expected'
, @Actual = N'#actual'
, @FailMsg = N'Incorrect headlines returned';

END
GO
--
-- END TEST
-- 



-- test
EXEC tsqlt.run '[tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]';
GO




-- however, not all content items have ratings
-- if needed: DELETE dbo.ContentPerformanceRecord WHERE ContentItemID > 10
SELECT
    ci.ContentItemID
  , cpr.ContentItemID
  FROM
    dbo.ContentItems AS ci
  LEFT OUTER JOIN dbo.ContentPerformanceRecord AS cpr
  ON
    cpr.ContentItemID = ci.ContentItemID;

GO





-- let's change the procedure
-- Add LOJ and ISNULL items
ALTER PROCEDURE dbo.GetArticleHeadlines
AS
BEGIN
SELECT TOP 5
    ci.ContentItemID
   ,ci.Title
   ,ci.ExternalURL
   , ISNULL(cpr.AverageRating,'0') AS 'AverageRating'
   , ISNULL(cpr.ViewsLastNDays,'0') AS 'ViewsLastNDays'
   , ISNULL(cpr.TotalViews,'0') AS 'TotalViews'
  FROM
    dbo.ContentItems AS ci
  LEFT OUTER JOIN dbo.ContentPerformanceRecord AS cpr
  ON
    cpr.ContentItemID = ci.ContentItemID; 
END
go


-- check
EXEC dbo.GetArticleHeadlines;
go




-- seems to work
-- let's test
-- test
EXEC tsqlt.run '[tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]';
GO










/*******************************************************************************
*                                                                              *
*                            END DEMO                                          *
*                                                                              *
********************************************************************************/

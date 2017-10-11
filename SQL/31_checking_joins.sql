/*
Unit Testing T-SQL - Checking Joins

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- We want to alter a table.
USE [TestingTSQL]
GO

-- we have a procedure using a join
-- DROP PROCEDURE dbo.GetArticleHeadlines
CREATE PROCEDURE dbo.GetArticleHeadlines
AS
BEGIN
SELECT TOP 5
    ci.ContentItemID
   ,ci.Title
   ,ci.ExternalURL
  , cpr.AverageRating
   ,cpr.ViewsLastNDays
   ,cpr.TotalViews
  FROM
    dbo.ContentItems AS ci
  INNER JOIN dbo.ContentPerformanceRecord AS cpr
  ON
    cpr.ContentItemID = ci.ContentItemID
ORDER BY ci.ContentItemID desc

END
go



-- this returns current headlines.
EXEC dbo.GetArticleHeadlines;




-- build a test
EXEC tsqlt.NewTestClass
  @ClassName = N'tContentTests';
GO
CREATE PROCEDURE [tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]
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






-- test
EXEC tsqlt.run '[tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]';
GO









-- We get a bug report
-- Some headlines don't appear.
-- Check
SELECT * FROM dbo.ContentItems ORDER BY ContentItemID desc
EXEC dbo.GetArticleHeadlines;

-- Hmmmm







-- While debugging, we realize in production, 
-- not all content items have ratings
-- if needed: DELETE dbo.ContentPerformanceRecord WHERE ContentItemID > 5
SELECT TOP 5
    ci.ContentItemID
  , cpr.ContentItemID
  FROM
    dbo.ContentItems AS ci
  LEFT OUTER JOIN dbo.ContentPerformanceRecord AS cpr
  ON
    cpr.ContentItemID = ci.ContentItemID
	ORDER BY ci.ContentItemID desc;

GO

-- alter the test
-- all we need to change is our Expected table
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
 (9, 4.0, 10, 20 )
,(10, 5.2, 20, 40 )
,(11, 6.5, 40, 80 )

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
 ( 9, 'Test 9', 'http://someurl.com/9/', 4.0, 10, 20 )
,( 10, 'Test 10', 'http://someurl.com/10/', 5.2, 20, 40 )
,( 11, 'Test 11', 'http://someurl.com/11/', 6.5, 40, 80 )
, (8, 'Test 8', 'http://someurl.com/8/', 0, 0, 0)
, (7, 'Test 7', 'http://someurl.com/7/', 0, 0, 0)

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

-- Let's test
EXEC tsqlt.run '[tContentTests].[test GetArticleHeadlines for headlines and ratings, and views]';
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
  , AverageRating = ISNULL(cpr.AverageRating,'0')
   ,ViewsLastNDays = ISNULL(cpr.ViewsLastNDays,'0')
   ,TotalViews =ISNULL(cpr.TotalViews,'0')
  FROM
    dbo.ContentItems AS ci
  LEFT OUTER JOIN dbo.ContentPerformanceRecord AS cpr
  ON
    cpr.ContentItemID = ci.ContentItemID
ORDER BY ci.ContentItemID desc; 
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

/* 

Unit Testing with SQL Server
Test Heuristics

Let's look at a series of tests that can help us catch problematic requirements.

Requirements

Copyright 2015, Sebastian Meine and Steve Jones

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.

*/
USE TestingTSQL
GO

EXEC tSQLt.NewTestClass 'MonthlyEmailTests';
GO
CREATE PROCEDURE MonthlyEmailTests.[test dbo.SendMonthlyNotificationEmail is not called when table is empty]
AS
BEGIN
  EXEC tSQLt.FakeTable @TableName = 'dbo.MonthlyNotificationRecipients';
  EXEC tSQLt.SpyProcedure @ProcedureName = 'dbo.SendMonthlyNotificationEmail';

  EXEC dbo.SendMonthlyNotifications;

  EXEC tSQLt.AssertEmptyTable @TableName = 'dbo.SendMonthlyNotificationEmail_SpyProcedureLog';

END;
GO
CREATE PROCEDURE MonthlyEmailTests.[test dbo.SendMonthlyNotificationEmail is not called once for single recipient]
AS
BEGIN
  EXEC tSQLt.FakeTable @TableName = 'dbo.MonthlyNotificationRecipients';
  EXEC tSQLt.SpyProcedure @ProcedureName = 'dbo.SendMonthlyNotificationEmail';

  INSERT INTO dbo.MonthlyNotificationRecipients(name,email)
  VALUES('Jon Dow','jon@dow.org');

  EXEC dbo.SendMonthlyNotifications;

  SELECT recipient_name,recipient_email
    INTO #Actual
    FROM dbo.SendMonthlyNotificationEmail_SpyProcedureLog;

  SELECT TOP(0) *
  INTO #Expected
  FROM #Actual;

  INSERT INTO #Expected
  VALUES('Jon Dow','jon@dow.org');

  EXEC tSQLt.AssertEqualsTable '#Expected','#Actual';
  
END;
GO
CREATE PROCEDURE MonthlyEmailTests.[test dbo.SendMonthlyNotificationEmail is not called once each for a few recipients]
AS
BEGIN
  EXEC tSQLt.FakeTable @TableName = 'dbo.MonthlyNotificationRecipients';
  EXEC tSQLt.SpyProcedure @ProcedureName = 'dbo.SendMonthlyNotificationEmail';

  INSERT INTO dbo.MonthlyNotificationRecipients(name,email)
  VALUES ('Jon Dow','jon@dow.org')
       , ('Jane Dow','jane@dow.org')
	   , ('Bob Smith','bob.smith@ymfse.com');

  EXEC dbo.SendMonthlyNotifications;

  SELECT recipient_name,recipient_email
    INTO #Actual
    FROM dbo.SendMonthlyNotificationEmail_SpyProcedureLog;

  SELECT recipient_name,recipient_email
    FROM dbo.SendMonthlyNotificationEmail_SpyProcedureLog;

  SELECT TOP(0) *
  INTO #Expected
  FROM #Actual;

  INSERT INTO #Expected
  VALUES ('Jon Dow','jon@dow.org')
       , ('Jane Dow','jane@dow.org')
	   , ('Bob Smith','bob.smith@ymfse.com');

  EXEC tSQLt.AssertEqualsTable '#Expected','#Actual';
  
END;
GO
EXEC tsqlt.run 'MonthlyEmailTests'
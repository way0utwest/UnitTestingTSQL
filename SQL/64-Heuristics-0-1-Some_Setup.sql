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

IF OBJECT_ID('dbo.MonthlyNotificationRecipients') IS NOT NULL DROP TABLE dbo.MonthlyNotificationRecipients;
IF OBJECT_ID('dbo.SendMonthlyNotifications') IS NOT NULL DROP PROCEDURE dbo.SendMonthlyNotifications;
IF OBJECT_ID('dbo.SendMonthlyNotificationEmail') IS NOT NULL DROP PROCEDURE dbo.SendMonthlyNotificationEmail;
IF OBJECT_ID('dbo.MonthlyNotificationRecipients') IS NOT NULL DROP TABLE dbo.MonthlyNotificationRecipients;
GO
CREATE TABLE dbo.MonthlyNotificationRecipients(
  name NVARCHAR(200) PRIMARY KEY CLUSTERED,
  email NVARCHAR(200)
);
GO
CREATE OR ALTER PROCEDURE dbo.SendMonthlyNotificationEmail
  @recipient_name NVARCHAR(200),
  @recipient_email NVARCHAR(200)
AS
BEGIN
  RAISERROR('TODO: Implement email functionality',16,10);
END;
GO
CREATE OR ALTER PROCEDURE dbo.SendMonthlyNotifications
AS
BEGIN
  DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT MNR.email, MNR.name
      FROM dbo.MonthlyNotificationRecipients AS MNR
     ORDER BY MNR.name;

  DECLARE @name NVARCHAR(200);
  DECLARE @email NVARCHAR(200);

  OPEN cur;
  WHILE(1=1)
  BEGIN
    FETCH NEXT FROM cur INTO @email, @name;
    IF(@@FETCH_STATUS <> 0)BREAK;

--
-- Email has the following format:    
--  
-- 
-- TO: {email}
-- SUBJECT: your monthly report
-- BODY:
--    
-- Dear {name}
--    
--  [include the report here]
--    
--  please let us know immediately, 
--  if there are any concerns with the data.
--    
-- Sincerely
--
-- Dr. Boo
--    

    EXEC dbo.SendMonthlyNotificationEmail @recipient_name = @name, @recipient_email = @email;

    --Get next record
    FETCH NEXT FROM cur INTO @email, @name;
  END  
END;
GO

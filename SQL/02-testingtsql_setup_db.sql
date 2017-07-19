/*
Testing T-SQL Made Easy - Setup

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- create the database
USE master
GO
IF NOT EXISTS( SELECT name FROM master.sys.databases WHERE name = 'TestingTSQL')
  CREATE DATABASE TestingTSQL
GO
ALTER DATABASE TestingTSQL SET TRUSTWORTHY ON;
GO
EXEC sp_configure 'clr enabled', 1
GO
reconfigure

-- drop database TestingTSQL
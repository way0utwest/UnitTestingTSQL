/*
Testing T-SQL Made Easy - Table Setup

Steve Jones, copyright 2016

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

-- change the database
USE TestingTSQL;
GO
/*
Run this script on:

        .\SQL2012.TestingTSQL    -  This database will be modified

to synchronize it with:

        .\SQL2012.SQLServerCentral

You are recommended to back up your database before running this script

Script created by SQL Compare version 11.5.0 from Red Gate Software Ltd at 4/24/2016 11:44:28 AM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC Off
GO
PRINT N'Creating [dbo].[Tags]'
GO
CREATE TABLE [dbo].[Tags]
(
[TagID] [int] NOT NULL IDENTITY(1, 1),
[TagText] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [tinyint] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Tags] on [dbo].[Tags]'
GO
ALTER TABLE [dbo].[Tags] ADD CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED  ([TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET NOEXEC off
PRINT N'Creating [dbo].[ContentItems]'
GO
CREATE TABLE [dbo].[ContentItems]
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
[CreatedDate] [datetime] NOT NULL,
[LastModifiedDate] [datetime] NULL,
[DollarValue] [float] NULL,
[IconFileID] [int] NULL,
[DisplayStyle] [int] NOT NULL CONSTRAINT [DF_ContentItems_DisplayStyle1] DEFAULT ((0)),
[PopularityRank] [float] NOT NULL CONSTRAINT [DF__ContentIt__Popul__5F7E2DAC1] DEFAULT ((0)),
[EstimateofReadingTime] [time] NOT NULL
)
GO

IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ContentItems] on [dbo].[ContentItems]'
GO
ALTER TABLE [dbo].[ContentItems] ADD CONSTRAINT [PK_ContentItems] PRIMARY KEY CLUSTERED  ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Articles]'
GO
CREATE TABLE [dbo].[Articles]
(
[ContentItemID] [int] NOT NULL,
[LoginRequired] [bit] NOT NULL CONSTRAINT [DF__Articles__LoginR__59C55456] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Articles] on [dbo].[Articles]'
GO
ALTER TABLE [dbo].[Articles] ADD CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED  ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Users]'
GO
CREATE TABLE [dbo].[Users]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
[SingleSignonMemberID] [int] NOT NULL,
[EmailAddress] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyID] [int] NULL,
[Biography] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostCode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorFirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorLastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorFullName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorForumID] [int] NULL,
[IsRegularAuthor] [bit] NOT NULL CONSTRAINT [DF_Users_IsRegularAuthor] DEFAULT ((0)),
[LastLoginDate] [datetime] NOT NULL,
[PaymentDetails] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Users] on [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UserPoints]'
GO
CREATE TABLE [dbo].[UserPoints]
(
[UserPointsRecordID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[Date] [smalldatetime] NOT NULL,
[PointsScored] [int] NOT NULL,
[PointsCategory] [int] NOT NULL,
[pointweight] [numeric] (3, 1) NULL CONSTRAINT [df_one] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UserPoints] on [dbo].[UserPoints]'
GO
ALTER TABLE [dbo].[UserPoints] ADD CONSTRAINT [PK_UserPoints] PRIMARY KEY CLUSTERED  ([UserPointsRecordID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [NCI_UserPoints_User] on [dbo].[UserPoints]'
GO
CREATE NONCLUSTERED INDEX [NCI_UserPoints_User] ON [dbo].[UserPoints] ([UserID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ContentPerformanceRecord]'
GO
CREATE TABLE [dbo].[ContentPerformanceRecord]
(
[ContentPerformanceRecordID] [int] NOT NULL IDENTITY(1, 1),
[ContentItemID] [int] NOT NULL,
[Day] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_Day] DEFAULT ((0)),
[CountOfViews] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_CountOfViews] DEFAULT ((0)),
[TotalRatings] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_CountOfRatings] DEFAULT ((0)),
[AverageRating] [numeric] (18, 4) NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_AverageRating] DEFAULT ((0)),
[ViewsLastNDays] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_ViewsLastNDays] DEFAULT ((0)),
[TotalViews] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_TotalViews] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ContentPerformanceRecord] on [dbo].[ContentPerformanceRecord]'
GO
ALTER TABLE [dbo].[ContentPerformanceRecord] ADD CONSTRAINT [PK_ContentPerformanceRecord] PRIMARY KEY CLUSTERED  ([ContentPerformanceRecordID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[TagMappings]'
GO
CREATE TABLE [dbo].[TagMappings]
(
[TagMappingID] [int] NOT NULL IDENTITY(1, 1),
[TagID] [int] NOT NULL,
[ContentItemID] [int] NOT NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_TagMappings_CreatedDate] DEFAULT (getdate())
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_TagMappings] on [dbo].[TagMappings]'
GO
ALTER TABLE [dbo].[TagMappings] ADD CONSTRAINT [PK_TagMappings] PRIMARY KEY CLUSTERED  ([TagMappingID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [NCI_TagMappings_Tags] on [dbo].[TagMappings]'
GO
CREATE NONCLUSTERED INDEX [NCI_TagMappings_Tags] ON [dbo].[TagMappings] ([TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Scripts]'
GO
CREATE TABLE [dbo].[Scripts]
(
[ContentItemID] [int] NOT NULL,
[SqlCode] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rgtool] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Scripts] on [dbo].[Scripts]'
GO
ALTER TABLE [dbo].[Scripts] ADD CONSTRAINT [PK_Scripts] PRIMARY KEY CLUSTERED  ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Questions]'
GO
CREATE TABLE [dbo].[Questions]
(
[ContentItemID] [int] NOT NULL,
[PointsValue] [int] NOT NULL,
[Explanation] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Questions] on [dbo].[Questions]'
GO
ALTER TABLE [dbo].[Questions] ADD CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED  ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[spGetUserScore]'
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF

CREATE PROCEDURE [dbo].[spGetUserScore]
  @userid INT
AS

BEGIN TRY
  SELECT u.UserID
      ,  u.DisplayName
	  , 'Points' = SUM( up.PointsScored)
   FROM dbo.Users AS u
    INNER JOIN dbo.UserPoints AS up
	 ON up.UserID = u.UserID
    WHERE u.UserID = @userid
	GROUP BY 
	 u.UserID
   , u.DisplayName
END TRY
BEGIN CATCH
  THROW 51000, 'Please pass in a User ID', 1
END CATCH
 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[spGetUserAverage]'
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF

CREATE PROCEDURE [dbo].[spGetUserAverage]
  @userid INT
  , @catid int
AS

BEGIN TRY
  SELECT u.UserID
      ,  u.DisplayName
	  , up.PointsCategory
	  , 'AveragePoints' = SUM( up.PointsScored) / sum(up.PointsCategory)
   FROM dbo.Users AS u
    INNER JOIN dbo.UserPoints AS up
	 ON up.UserID = u.UserID
    WHERE u.UserID = @userid
	AND up.PointsCategory = @catid
	GROUP BY 
	 u.UserID
   , u.DisplayName
   , up.PointsCategory
END TRY
BEGIN CATCH
  THROW 51000, 'Please pass in a User ID', 1
END CATCH
 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AuthorContentItem]'
GO
CREATE TABLE [dbo].[AuthorContentItem]
(
[ContentItemID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[ordering] [tinyint] NOT NULL CONSTRAINT [DF_AuthorContentItem_ordering] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AuthorContentItem] on [dbo].[AuthorContentItem]'
GO
ALTER TABLE [dbo].[AuthorContentItem] ADD CONSTRAINT [PK_AuthorContentItem] PRIMARY KEY CLUSTERED  ([ContentItemID], [UserID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetPublishedArticleAuthorUserIDs]'
GO
CREATE PROCEDURE [dbo].[GetPublishedArticleAuthorUserIDs] 
AS
BEGIN
	-- Just returns the user IDs of all the users who have had articles published
	-- Is called by the mailing feature when sending emails to "all article authors"
	SELECT DISTINCT u.[UserID]
	FROM Users u
	JOIN [AuthorContentItem] aci ON aci.[UserID]=u.[UserID]
	JOIN ContentItems ci ON aci.[ContentItemID]=ci.[ContentItemID]
	JOIN [Articles] a ON ci.[ContentItemID] = a.[ContentItemID] /* Only articles */
	WHERE ci.[PublishingStatus] IN (30 /*Published*/, 25 /*Pending publish*/)
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetPopularTags]'
GO
CREATE PROCEDURE [dbo].[GetPopularTags] 
	@ContentType VARCHAR(20),
	@MaxResults INT
AS
BEGIN

SET ROWCOUNT @MaxResults

IF @ContentType = 'Article'
BEGIN
	
	SELECT t.TagID
          ,t.TagText
          ,t.Status
	FROM Tags t
	INNER JOIN dbo.TagMappings tm ON t.TagID = tm.TagID
	INNER JOIN dbo.Articles a ON tm.ContentItemID = a.ContentItemID
	GROUP BY t.TagText, t.TagID, t.Status
	ORDER BY CASE t.TagText WHEN 'Video' THEN 1 ELSE 0 END DESC, COUNT(a.ContentItemID) DESC
	
END ELSE IF @ContentType = 'Script' 
BEGIN
	SELECT t.TagID
          ,t.TagText
          ,t.Status
	FROM Tags t
	INNER JOIN dbo.TagMappings tm ON t.TagID = tm.TagID
	INNER JOIN dbo.Scripts s ON tm.ContentItemID = s.ContentItemID
	GROUP BY t.TagText, t.TagID, t.status
	ORDER BY COUNT(s.ContentItemID) DESC									
END	ELSE BEGIN
	SELECT t.TagID
          ,t.TagText
          ,t.Status
	FROM Tags t
	INNER JOIN dbo.TagMappings tm ON t.TagID = tm.TagID
	INNER JOIN dbo.ContentItems c ON tm.ContentItemID = c.ContentItemID
	GROUP BY t.TagText, t.TagID, t.Status
	ORDER BY COUNT(c.ContentItemID) DESC															
END
	
SET ROWCOUNT 0
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetPopularContent]'
GO
CREATE PROCEDURE [dbo].[GetPopularContent] 
@ContentType VARCHAR(30) = NULL,
@MaxResults  INT = 20
AS
BEGIN 

IF @ContentType = 'Article'
	SELECT TOP (@MaxResults) ci.ContentItemID
	FROM dbo.ContentItems ci
	JOIN Articles a ON a.ContentItemID = ci.ContentItemID
	ORDER BY ci.PopularityRank DESC
ELSE IF @ContentType = 'Script'
	SELECT TOP (@MaxResults) ci.ContentItemID
	FROM dbo.ContentItems ci
	JOIN Scripts s ON s.ContentItemID = ci.ContentItemID
	ORDER BY ci.PopularityRank DESC
ELSE 
	SELECT TOP (@MaxResults) ci.[ContentItemID] 
	FROM dbo.ContentItems ci
	ORDER BY ci.PopularityRank desc
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ContentItemsScheduledRelease]'
GO
CREATE TABLE [dbo].[ScheduleEntries]
(
[ScheduleEntryID] [int] NOT NULL IDENTITY(1, 1),
[ContentItemID] [int] NOT NULL,
[Site] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[SortOrder] [float] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ScheduleEntries] on [dbo].[ScheduleEntries]'
GO
ALTER TABLE [dbo].[ScheduleEntries] ADD CONSTRAINT [PK_ScheduleEntries] PRIMARY KEY CLUSTERED  ([ScheduleEntryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetTagMappingsData]'
GO


PRINT N'Creating [dbo].[MoveAllTagMappings]'
GO
CREATE PROCEDURE [dbo].[MoveAllTagMappings] 
	@FromTagText nvarchar(100),
	@ToTagID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Moving tag mappings to themselves should do nothing
	IF NOT EXISTS(SELECT * FROM Tags where TagID=@ToTagID and TagText=@FromTagText)
	BEGIN
		-- Don't move tagmappings when the same tag/contentitem pair already exists
		UPDATE tm
		SET tm.TagID = @ToTagID
		FROM [TagMappings] tm
		JOIN Tags t ON t.[TagID]=tm.[TagID]
		LEFT OUTER JOIN [TagMappings] tm_existing 
			ON [tm_existing].[TagID] = @toTagID
			AND [tm_existing].[ContentItemID] = tm.[ContentItemID]
		WHERE t.[TagText]=@FromTagText
		AND [tm_existing].[TagMappingID] IS NULL

		-- Erase any that were left because the same tag/contentitem pair already exists
		DELETE FROM [TagMappings] 
		WHERE [TagID] IN (SELECT TagID FROM [Tags] WHERE [TagText]=@FromTagText)
	END
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ArticleSeries]'
GO
CREATE TABLE [dbo].[ArticleSeries]
(
[ContentItemID] [int] NOT NULL,
[BannerImageFileID] [int] NULL,
[AdvertImageID] [int] NULL,
[AdvertUrl] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsStairwaySeries] [bit] NOT NULL CONSTRAINT [DF__ArticleSe__IsSta__5AB9788F] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__ArticleS__B851BC8C80872D52] on [dbo].[ArticleSeries]'
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [PK__ArticleS__B851BC8C80872D52] PRIMARY KEY CLUSTERED  ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answers]'
GO
CREATE TABLE [dbo].[Answers]
(
[AnswerID] [int] NOT NULL IDENTITY(1, 1),
[ContentItemID] [int] NOT NULL,
[AnswerText] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsCorrect] [bit] NOT NULL,
[SortOrder] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Answers] on [dbo].[Answers]'
GO
ALTER TABLE [dbo].[Answers] ADD CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED  ([AnswerID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FileBlobs]'
GO
CREATE TABLE [dbo].[FileBlobs]
(
[FileID] [int] NOT NULL IDENTITY(1, 1),
[Data] [image] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FileBlobs] on [dbo].[FileBlobs]'
GO
ALTER TABLE [dbo].[FileBlobs] ADD CONSTRAINT [PK_FileBlobs] PRIMARY KEY CLUSTERED  ([FileID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[QuestionAttempt]'
GO
CREATE TABLE [dbo].[QuestionAttempt]
(
[AttemptID] [int] NOT NULL IDENTITY(1, 1),
[QuestionID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[SubmittedDate] [datetime] NOT NULL,
[WasCorrect] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_QuestionAttempt] on [dbo].[QuestionAttempt]'
GO
ALTER TABLE [dbo].[QuestionAttempt] ADD CONSTRAINT [PK_QuestionAttempt] PRIMARY KEY CLUSTERED  ([AttemptID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[QuestionAttemptAnswers]'
GO
CREATE TABLE [dbo].[QuestionAttemptAnswers]
(
[AttemptID] [int] NOT NULL,
[AnswerID] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Files]'
GO
CREATE TABLE [dbo].[Files]
(
[FileID] [int] NOT NULL,
[FileName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileExtension] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SizeInBytes] [bigint] NOT NULL,
[CreatedDate] [datetime] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Files] on [dbo].[Files]'
GO
ALTER TABLE [dbo].[Files] ADD CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED  ([FileID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[BriefcaseEntries]'
GO
CREATE TABLE [dbo].[BriefcaseEntries]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ContentItemID] [int] NOT NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastModifiedDate] [datetime] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__Briefcas__3214EC07FEA76CF5] on [dbo].[BriefcaseEntries]'
GO
ALTER TABLE [dbo].[BriefcaseEntries] ADD CONSTRAINT [PK__Briefcas__3214EC07FEA76CF5] PRIMARY KEY CLUSTERED  ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[BriefcaseEntryTags]'
GO
CREATE TABLE [dbo].[BriefcaseEntryTags]
(
[EntryId] [int] NOT NULL,
[TagID] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Adverts]'
GO
CREATE TABLE [dbo].[Adverts]
(
[ContentItemID] [int] NOT NULL,
[PlainTextRepresentation] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Adverts] on [dbo].[Adverts]'
GO
ALTER TABLE [dbo].[Adverts] ADD CONSTRAINT [PK_Adverts] PRIMARY KEY CLUSTERED  ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[QuestionAttemptAnswers]'
GO
ALTER TABLE [dbo].[QuestionAttemptAnswers] ADD CONSTRAINT [FK_QuestionAttemptAnswer_Answers] FOREIGN KEY ([AnswerID]) REFERENCES [dbo].[Answers] ([AnswerID])
GO
ALTER TABLE [dbo].[QuestionAttemptAnswers] ADD CONSTRAINT [FK_QuestionAttemptAnswer_QuestionAttempt] FOREIGN KEY ([AttemptID]) REFERENCES [dbo].[QuestionAttempt] ([AttemptID]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[Answers]'
GO
ALTER TABLE [dbo].[Answers] ADD CONSTRAINT [FK_Answers_Questions] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[Questions] ([ContentItemID]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ArticleSeries]'
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [FK17BABB2DA18B6AD] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [FK17BABB2DABD78FE] FOREIGN KEY ([BannerImageFileID]) REFERENCES [dbo].[Files] ([FileID])
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [FK17BABB2D914BD28] FOREIGN KEY ([AdvertImageID]) REFERENCES [dbo].[Files] ([FileID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[BriefcaseEntryTags]'
GO
ALTER TABLE [dbo].[BriefcaseEntryTags] ADD CONSTRAINT [FKF19C93BBF75AD759] FOREIGN KEY ([EntryId]) REFERENCES [dbo].[BriefcaseEntries] ([Id])
GO
ALTER TABLE [dbo].[BriefcaseEntryTags] ADD CONSTRAINT [FKF19C93BB4B097D93] FOREIGN KEY ([TagID]) REFERENCES [dbo].[Tags] ([TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[BriefcaseEntries]'
GO
ALTER TABLE [dbo].[BriefcaseEntries] ADD CONSTRAINT [FKC43F472254A2F41C] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[BriefcaseEntries] ADD CONSTRAINT [FKC43F4722A18B6AD] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[Questions]'
GO
ALTER TABLE [dbo].[Questions] ADD CONSTRAINT [FK_Questions_ContentItems] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ScheduleEntries]'
GO
ALTER TABLE [dbo].[ScheduleEntries] ADD CONSTRAINT [FK_ScheduleEntries_ContentItems] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[TagMappings]'
GO
ALTER TABLE [dbo].[TagMappings] ADD CONSTRAINT [FK_TagMappings_ContentItems] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
ALTER TABLE [dbo].[TagMappings] ADD CONSTRAINT [FK_TagMappings_Tags] FOREIGN KEY ([TagID]) REFERENCES [dbo].[Tags] ([TagID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ContentItems]'
GO
ALTER TABLE [dbo].[ContentItems] ADD CONSTRAINT [FK_ContentItems_Tags] FOREIGN KEY ([PrimaryTagID]) REFERENCES [dbo].[Tags] ([TagID])
GO
ALTER TABLE [dbo].[ContentItems] ADD CONSTRAINT [FK_ContentItems_FileBlobs] FOREIGN KEY ([IconFileID]) REFERENCES [dbo].[FileBlobs] ([FileID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[QuestionAttempt]'
GO
ALTER TABLE [dbo].[QuestionAttempt] ADD CONSTRAINT [FK_QuestionAttempt_Questions] FOREIGN KEY ([QuestionID]) REFERENCES [dbo].[Questions] ([ContentItemID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[QuestionAttempt] ADD CONSTRAINT [FK_QuestionAttempt_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[UserPoints]'
GO
ALTER TABLE [dbo].[UserPoints] ADD CONSTRAINT [FK_UserPoints_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE
GO
ALTER TABLE dbo.BriefcaseEntryTags ADD CONSTRAINT
	PK_BriefcaseEntryTags PRIMARY KEY CLUSTERED 
	(
	EntryId,
	TagID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.QuestionAttemptAnswers ADD CONSTRAINT
	PK_QuestionAttemptAnswers PRIMARY KEY CLUSTERED 
	(
	AttemptID,
	AnswerID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE FUNCTION dbo.clrLoadFileMetadata
 (
  @fileid INT
 )
 RETURNS VARCHAR(1000)
 AS
 BEGIN
   RETURN REPLICATE('a', 50)
 END
 GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

IF OBJECT_ID('dbo.UF_CalcDiscountForSale') IS NOT NULL
    DROP FUNCTION dbo.UF_CalcDiscountForSale;
GO
CREATE FUNCTION dbo.UF_CalcDiscountForSale ( @QtyPurchased INT )
RETURNS NUMERIC(10 ,3)
AS
    BEGIN
        DECLARE @i NUMERIC(10,3);

        SELECT  @i = CASE WHEN ( @QtyPurchased > 101 ) THEN 0.1
                          WHEN ( @QtyPurchased > 20 ) AND (@QtyPurchased < 100)
                               THEN 0.05
                          ELSE 0.0
                     END

        RETURN @i
    END

GO
GO
IF OBJECT_ID('dbo.clrLoadFileMetadata') IS NOT NULL
  DROP FUNCTION dbo.clrLoadFileMetadata
go
CREATE FUNCTION dbo.clrLoadFileMetadata(@fileid int)
RETURNS TABLE
AS
    RETURN 
	( SELECT summary = 'This is a file summary.'
	)
go
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO




/****** Object:  Table [dbo].[ScheduleEntries]    Script Date: 4/27/2016 5:23:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE UserTempPwd
( UserID INT PRIMARY KEY
, temppwd VARBINARY(MAX)
, PasswordExpires DATETIME2(3)
);
GO



CREATE TABLE SalesOrderDetail
( SalesOrderID INT
, SalesOrderDetailID INT PRIMARY KEY NONCLUSTERED
, OrderQuantity INT
, ProductID INT
, UnitPrice MONEY
, DiscountPercent NUMERIC(10,4)
, LineTotal MONEY
, TaxAmount MONEY
, ShippingState VARCHAR(3)
);

INSERT INTO dbo.SalesOrderDetail
( SalesOrderID, SalesOrderDetailID, OrderQuantity, ProductID, UnitPrice, DiscountPercent, LineTotal, TaxAmount, ShippingState)
VALUES  ( 1, 1, 10, 2, 10, 0.0, 100, 2, 'PA')
      , ( 1, 2, 22, 3, 5, 0.1, 100, 5, 'GA')
      , ( 2, 3, 5, 2, 4, 0.15, 17, 0.85 , 'GA')
      , ( 2, 4, 12, 3, 10, 0.1, 108, 2.268, 'CO')
      , ( 2, 5, 5, 4, 60, 0.0, 300, 18.60, 'CA')
;



IF OBJECT_ID('dbo.Salestax') IS NOT NULL
  DROP TABLE dbo.Salestax;
-- Create the sales tax table
CREATE TABLE dbo.Salestax (
   statecode VARCHAR(2) PRIMARY KEY,
   taxamount NUMERIC(4, 3)
  );
GO
-- insert sales tax data
INSERT  dbo.Salestax
        ( statecode, taxamount )
VALUES  ( 'AK', 0.0714 ),
        ( 'AL', 0.0214 ),
        ( 'AR', 0.034 ),
        ( 'AZ', 0.011 ),
        ( 'CA', 0.062 ),
        ( 'CO', 0.021 ),
        ( 'CT', 0.064 ),
        ( 'DE', 0.032 ),
        ( 'FL', 0.06 ),
        ( 'GA', 0.05 ),
        ( 'HI', 0.08 ),
        ( 'IA', 0.044 ),
        ( 'ID', 0.031 ),
        ( 'IL', 0.074 ),
        ( 'IN', 0.071 ),
        ( 'KS', 0.074 ),
        ( 'KY', 0.074 ),
        ( 'LA', 0.071 ),
        ( 'MA', 0.071 ),
        ( 'MD', 0.071 ),
        ( 'ME', 0.074 ),
        ( 'MI', 0.0714 ),
        ( 'MN', 0.0714 ),
        ( 'MO', 0.0714 ),
        ( 'MS', 0.0714 ),
        ( 'MT', 0.0714 ),
        ( 'NC', 0.0714 ),
        ( 'ND', 0.0714 ),
        ( 'NE', 0.0714 ),
        ( 'NH', 0.0714 ),
        ( 'NJ', 0.0714 ),
        ( 'NM', 0.0714 ),
        ( 'NV', 0.0714 ),
        ( 'NY', 0.0714 ),
        ( 'OH', 0.0714 ),
        ( 'OK', 0.0714 ),
        ( 'OR', 0.0714 ),
        ( 'PA', 0.02 ),
        ( 'RI', 0.0714 ),
        ( 'SC', 0.0714 ),
        ( 'SD', 0.0714 ),
        ( 'TN', 0.0714 ),
        ( 'TX', 0.0714 ),
        ( 'UT', 0.0714 ),
        ( 'VA', 0.0714 ),
        ( 'VT', 0.074 ),
        ( 'WA', 0.071 ),
        ( 'WI', 0.024 ),
        ( 'WV', 0.014 ),
        ( 'WY', 0.014 );
GO
-- create unique index
CREATE UNIQUE INDEX IX_RegionTax ON dbo.Salestax (statecode, taxamount) 
GO

IF OBJECT_ID('dbo.CalcSalesTaxForSale') IS NOT NULL
  DROP FUNCTION dbo.CalcSalesTaxForSale;
GO
-- create salestax calculation procedure
CREATE FUNCTION dbo.CalcSalesTaxForSale (
   @state CHAR(2),
   @amount NUMERIC(12, 3)
  )
RETURNS NUMERIC(12, 3)
AS
BEGIN
  DECLARE @tax NUMERIC(12, 3);

  SELECT  @tax = @amount * CASE WHEN @state = 'AK' THEN 0.05
                                WHEN @state = 'AL' THEN 0.02
                                WHEN @state = 'AR' THEN 0.04
                                WHEN @state = 'AZ' THEN 0.04
                                WHEN @state = 'CA' THEN 0.04
                                WHEN @state = 'CO' THEN 0.04
                                WHEN @state = 'CT' THEN 0.04
                                WHEN @state = 'DE' THEN 0.04
                                WHEN @state = 'FL' THEN 0.04
                                WHEN @state = 'GA' THEN 0.04
                                WHEN @state = 'HI' THEN 0.04
                                WHEN @state = 'IA' THEN 0.04
                                WHEN @state = 'ID' THEN 0.04
                                WHEN @state = 'IL' THEN 0.04
                                WHEN @state = 'IN' THEN 0.04
                                WHEN @state = 'KS' THEN 0.04
                                WHEN @state = 'KY' THEN 0.04
                                WHEN @state = 'LA' THEN 0.04
                                WHEN @state = 'MA' THEN 0.04
                                WHEN @state = 'MD' THEN 0.04
                                WHEN @state = 'ME' THEN 0.04
                                WHEN @state = 'MI' THEN 0.04
                                WHEN @state = 'MN' THEN 0.04
                                WHEN @state = 'MO' THEN 0.04
                                WHEN @state = 'MS' THEN 0.04
                                WHEN @state = 'MT' THEN 0.04
                                WHEN @state = 'NC' THEN 0.04
                                WHEN @state = 'ND' THEN 0.04
                                WHEN @state = 'NE' THEN 0.04
                                WHEN @state = 'NH' THEN 0.04
                                WHEN @state = 'NJ' THEN 0.04
                                WHEN @state = 'NM' THEN 0.04
                                WHEN @state = 'NV' THEN 0.04
                                WHEN @state = 'NY' THEN 0.04
                                WHEN @state = 'OH' THEN 0.04
                                WHEN @state = 'OK' THEN 0.04
                                WHEN @state = 'OR' THEN 0.04
                                WHEN @state = 'PS' THEN 0.02
                                WHEN @state = 'RI' THEN 0.04
                                WHEN @state = 'SC' THEN 0.04
                                WHEN @state = 'SD' THEN 0.04
                                WHEN @state = 'TN' THEN 0.04
                                WHEN @state = 'TX' THEN 0.04
                                WHEN @state = 'UT' THEN 0.04
                                WHEN @state = 'VA' THEN 0.04
                                WHEN @state = 'VT' THEN 0.04
                                WHEN @state = 'WA' THEN 0.04
                                WHEN @state = 'WI' THEN 0.04
                                WHEN @state = 'WV' THEN 0.04
                                WHEN @state = 'WY' THEN 0.04
                           END;
            
  RETURN @tax; 

END;
GO
IF OBJECT_ID('dbo.SetLocalTaxRate') IS NOT NULL DROP PROCEDURE dbo.SetLocalTaxRate;
GO
CREATE PROCEDURE dbo.SetLocalTaxRate
  @OrderId INT
AS
BEGIN
  UPDATE O 
  SET
         o.TaxAmount = o.LineTotal * dbo.CalcSalesTaxForSale(O.ShippingState,O.LineTotal)
    FROM dbo.SalesOrderDetail AS O
   WHERE O.SalesOrderDetailID = @OrderId;    
END;
GO

GO

﻿/*
Deployment script for MANET-DTN-MOCK

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "MANET-DTN-MOCK"
:setvar DefaultFilePrefix "MANET-DTN-MOCK"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                DATE_CORRELATION_OPTIMIZATION OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO, OPERATION_MODE = READ_WRITE, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating [dbo].[TransferLog]...';


GO
CREATE TABLE [dbo].[TransferLog] (
    [ItemID]             INT           NOT NULL,
    [OriginatorId]       NCHAR (10)    NOT NULL,
    [IsRemoveFlag]       TINYINT       NOT NULL,
    [TransFromID]        NVARCHAR (30) NOT NULL,
    [DateTimeTransfered] DATETIME      NOT NULL,
    CONSTRAINT [PK_TRANSFERLOG] PRIMARY KEY CLUSTERED ([ItemID] ASC, [IsRemoveFlag] ASC, [TransFromID] ASC, [OriginatorId] ASC)
);


GO
PRINT N'Creating [dbo].[RemoveFlag]...';


GO
CREATE TABLE [dbo].[RemoveFlag] (
    [ItemID]          INT           NOT NULL,
    [OriginatorID]    NVARCHAR (30) NOT NULL,
    [DateTimeFlagged] DATETIME      NOT NULL,
    CONSTRAINT [PK_REMOVEFLAG] PRIMARY KEY CLUSTERED ([ItemID] ASC, [OriginatorID] ASC)
);


GO
PRINT N'Creating [dbo].[Item]...';


GO
CREATE TABLE [dbo].[Item] (
    [ItemID]          INT             NOT NULL,
    [ItemType]        NVARCHAR (20)   NOT NULL,
    [PLevel]          NVARCHAR (20)   NOT NULL,
    [OriginatorID]    NVARCHAR (30)   NOT NULL,
    [RecipientID]     NVARCHAR (30)   NULL,
    [Title]           NVARCHAR (100)  NOT NULL,
    [Body]            NVARCHAR (1000) NOT NULL,
    [DateTimeCreated] DATETIME        NOT NULL,
    CONSTRAINT [PK_ITEM] PRIMARY KEY CLUSTERED ([ItemID] ASC, [OriginatorID] ASC)
);


GO
PRINT N'Creating [dbo].[PriorityLevel]...';


GO
CREATE TABLE [dbo].[PriorityLevel] (
    [PName] NVARCHAR (20) NOT NULL,
    CONSTRAINT [PK_PRIORITYLEVEL] PRIMARY KEY CLUSTERED ([PName] ASC)
);


GO
PRINT N'Creating [dbo].[ItemID_SEQ]...';


GO
CREATE SEQUENCE [dbo].[ItemID_SEQ]
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    CACHE 10;


GO
PRINT N'Creating [dbo].[FK_ITEM_PRIORITYLEVEL]...';


GO
ALTER TABLE [dbo].[Item]
    ADD CONSTRAINT [FK_ITEM_PRIORITYLEVEL] FOREIGN KEY ([PLevel]) REFERENCES [dbo].[PriorityLevel] ([PName]);


GO
PRINT N'Creating [dbo].[CHK_TYPE_RECIPIENT]...';


GO
ALTER TABLE [dbo].[Item]
    ADD CONSTRAINT [CHK_TYPE_RECIPIENT] CHECK (ItemType = 'DATA' AND RecipientID IS NULL 
										OR ItemType = 'MESSAGE' AND RecipientID IS NOT NULL);


GO
PRINT N'Creating [dbo].[RemoveIDList]...';


GO
CREATE VIEW [dbo].[RemoveIDList]
	AS SELECT ItemID FROM [RemoveFlag]
GO
PRINT N'Creating [dbo].[ItemView]...';


GO
CREATE VIEW [dbo].[ItemView]
	AS SELECT ItemID FROM [Item]
GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO

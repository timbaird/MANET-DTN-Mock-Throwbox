﻿/*
Deployment script for MANET_DTN_MOCK

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar LoadTestData "true"
:setvar DatabaseName "MANET_DTN_MOCK"
:setvar DefaultFilePrefix "MANET_DTN_MOCK"
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
PRINT N'Creating [dbo].[Item]...';


GO
CREATE TABLE [dbo].[Item] (
    [ItemID]          NVARCHAR (30)   NOT NULL,
    [ItemType]        NVARCHAR (20)   NOT NULL,
    [PriorityLevel]   NVARCHAR (20)   NOT NULL,
    [OriginatorID]    NVARCHAR (30)   NOT NULL,
    [RecipientID]     NVARCHAR (30)   NULL,
    [TransFromID]     NVARCHAR (30)   NOT NULL,
    [Title]           NVARCHAR (100)  NOT NULL,
    [Body]            NVARCHAR (1000) NOT NULL,
    [DateTimeCreated] DATETIME        NOT NULL,
    CONSTRAINT [PK_ITEM] PRIMARY KEY CLUSTERED ([ItemID] ASC)
);


GO
PRINT N'Creating [dbo].[RemoveFlag]...';


GO
CREATE TABLE [dbo].[RemoveFlag] (
    [ItemID]          NVARCHAR (30) NOT NULL,
    [OriginatorID]    NVARCHAR (30) NOT NULL,
    [DateTimeFlagged] DATETIME      NOT NULL,
    CONSTRAINT [PK_REMOVEFLAG] PRIMARY KEY CLUSTERED ([ItemID] ASC)
);


GO
PRINT N'Creating [dbo].[TransferLog]...';


GO
CREATE TABLE [dbo].[TransferLog] (
    [ItemID]             NVARCHAR (30) NOT NULL,
    [OriginatorId]       NVARCHAR (30) NOT NULL,
    [IsRemoveFlag]       TINYINT       NOT NULL,
    [TransFromID]        NVARCHAR (30) NOT NULL,
    [DateTimeTransfered] DATETIME      NOT NULL,
    CONSTRAINT [PK_TRANSFERLOG] PRIMARY KEY CLUSTERED ([ItemID] ASC, [IsRemoveFlag] ASC, [TransFromID] ASC)
);


GO
PRINT N'Creating [dbo].[CHK_ITEM_PRIORITYLEVEL]...';


GO
ALTER TABLE [dbo].[Item] WITH NOCHECK
    ADD CONSTRAINT [CHK_ITEM_PRIORITYLEVEL] CHECK (PriorityLevel IN ('HIGH', 'NORMAL', 'LOW'));


GO
PRINT N'Creating [dbo].[CHK_TYPE_RECIPIENT]...';


GO
ALTER TABLE [dbo].[Item] WITH NOCHECK
    ADD CONSTRAINT [CHK_TYPE_RECIPIENT] CHECK (ItemType = 'DATA' AND RecipientID IS NULL 
										OR ItemType = 'MESSAGE' AND RecipientID IS NOT NULL);


GO
PRINT N'Creating [dbo].[ItemIDList]...';


GO
CREATE VIEW [dbo].[ItemIDList]
	AS SELECT ItemID FROM [Item]
GO
PRINT N'Creating [dbo].[RemoveIDList]...';


GO
CREATE VIEW [dbo].[RemoveIDList]
	AS SELECT ItemID FROM [RemoveFlag]
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


IF '$(LoadTestData)' = 'true'

BEGIN
DELETE FROM Item;
DELETE FROM RemoveFlag;
DELETE FROM TransferLog;

INSERT INTO Item (ItemID, ItemType, PLevel, OriginatorID, RecipientID, Title, Body, DateTimeCreated) VALUES
('MAC:00:00:00:00:00:00-1', 'MESSAGE','NORMAL', 'MAC:00:00:00:00:00:00', 'PHO:+61438363012', 'Test Message', 'This is a message to test message sync functionality', SYSDATETIME()),
('MAC:00:00:00:00:00:00-2', 'DATA','NORMAL', 'MAC:00:00:00:00:00:00', NULL, 'Test Data', 'This is a data point to test data sync functionality', SYSDATETIME());

END;
GO

GO

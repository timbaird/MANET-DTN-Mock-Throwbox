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

INSERT INTO Item (ItemID, ItemType, PriorityLevel, OriginatorID, RecipientID, Title, Body, DateTimeCreated) VALUES
('MAC:00:00:00:00:00:00-1', 'MESSAGE','NORMAL', 'MAC:00:00:00:00:00:00', 'PHO:+61438363012', 'Test Message', 'This is a message to test message sync functionality', SYSDATETIME()),
('MAC:00:00:00:00:00:00-2', 'DATA','NORMAL', 'MAC:00:00:00:00:00:00', NULL, 'Test Data', 'This is a data point to test data sync functionality', SYSDATETIME());

END;
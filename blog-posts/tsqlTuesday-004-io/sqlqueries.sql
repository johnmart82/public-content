-- Set the format width of the columns returned by queries in SQLCMD.
-- // No need for this if using SSMS or ADS.
:SETVAR SQLCMDMAXVARTYPEWIDTH 40
:SETVAR SQLCMDMAXVARTYPEWIDTH 40
GO

-- Create a credential using the SAS Key we generated using the Azure CLI.
-- // The name of the credential is the URI path to the storage container we created earlier which is the contianer name appended to the primary endpoint URI.
-- // Make sure there is no trailing slash.
CREATE CREDENTIAL [https://sttsqltueio.blob.core.windows.net/sqlserverarchive]
    WITH
        IDENTITY = 'SHARED ACCESS SIGNATURE',
        SECRET = 'se=2024-03-01T20%3A01Z&sp=rwdlacup&spr=https&sv=2022-11-02&ss=b&srt=sco&sig=PNmvbvFuIQXq9jXk18Mgiq77UA/Yh1Yb2b7gMffsQek%3D'
;
GO


-- Check that we have a credenital
SELECT Name FROM sys.credentials;
GO

-- Create a small empty database.
CREATE DATABASE MyAppDb;
GO

-- Switch context to new database.
USE MyAppDb;
GO

-- Check the data and log files are local.
SELECT name, physical_name FROM sys.database_files;
GO

-- create a small table, insert some data, then query it.
CREATE TABLE dbo.myDataTable
(
    recId INT IDENTITY(1,1) PRIMARY KEY,
    dataValue VARCHAR(15) DEFAULT(REPLICATE('12345',3)),
    recYear INT
)
;
GO

INSERT INTO dbo.myDataTable(dataValue,recYear)
    VALUES(DEFAULT,2024);
GO 500
INSERT INTO dbo.myDataTable(dataValue,recYear)
    VALUES(DEFAULT,2023);
GO 2500
INSERT INTO dbo.myDataTable(dataValue,recYear)
    VALUES(DEFAULT,2022);
GO 1500
INSERT INTO dbo.myDataTable(dataValue,recYear)
    VALUES(DEFAULT,2021);
GO 500


SELECT * FROM dbo.myDataTable;
GO

-- Create new filegroup for our archive then add some files to it on the Azure blob storage.
USE master;
GO

ALTER DATABASE myAppDb
    ADD FILEGROUP cloudArchive;
GO

ALTER DATABASE myAppDb
    ADD FILE
    (
        NAME = cloudArchive1,
        FILENAME = 'https://sttsqltueio.blob.core.windows.net/sqlserverarchive/cloudarchive1.ndf',
        SIZE = 50MB,
        MAXSIZE = 100MB,
        FILEGROWTH = 5MB
    ),
    (
        NAME = cloudArchive2,
        FILENAME = 'https://sttsqltueio.blob.core.windows.net/sqlserverarchive/cloudarchive2.ndf',
        SIZE = 50MB,
        MAXSIZE = 100MB,
        FILEGROWTH = 5MB
    ),
    (
        NAME = cloudArchive3,
        FILENAME = 'https://sttsqltueio.blob.core.windows.net/sqlserverarchive/cloudarchive3.ndf',
        SIZE = 50MB,
        MAXSIZE = 100MB,
        FILEGROWTH = 5MB
    ),
    (
        NAME = cloudArchive4,
        FILENAME = 'https://sttsqltueio.blob.core.windows.net/sqlserverarchive/cloudarchive4.ndf',
        SIZE = 50MB,
        MAXSIZE = 100MB,
        FILEGROWTH = 5MB
    )
    TO FILEGROUP cloudArchive;
GO

-- Switch context to myAppDb database.
USE MyAppDb;
GO

-- Check the data and log files have been created on the blob storage.
SELECT name, physical_name FROM sys.database_files;
GO

--// Now go back to the Azure CLI and see the files there.

-- Lets setup a table on the archive filegorup and move some data.
CREATE TABLE dbo.myDataArchive
(
    recId INT PRIMARY KEY,
    dataValue VARCHAR(15),
    recYear INT
)
ON [cloudArchive]
;
GO

-- Archive data for 2021 and 2022 then add check constraints to tables.
BEGIN TRANSACTION archiveData;

    INSERT INTO dbo.myDataArchive(recId, dataValue, recYear)
    SELECT recId, dataValue, recYear FROM dbo.myDataTable WHERE recYear IN (2021,2022);

    DELETE FROM dbo.myDataTable WHERE recYear IN (2021,2022);
    
COMMIT TRANSACTION
GO

--Check rows counts per-table.
SELECT COUNT(*) AS countRows, 'myDataTable' AS tableName FROM dbo.myDataTable 
UNION
SELECT COUNT(*), 'myDataArchive' FROM dbo.myDataArchive 
;
GO

-- Create a view to show consolidated data output.
CREATE VIEW dbo.myDataView
AS
    SELECT recId, dataValue, recYear FROM dbo.myDataTable
    UNION ALL
    SELECT recId, dataValue, recYear FROM dbo.myDataArchive
;
GO

-- Enable actual execution plan collection in SSMS or ADS and then run the following queries to see where the data is served from when filtering by year.
SELECT * FROM dbo.myDataView WHERE recYear = 2021;
SELECT * FROM dbo.myDataView WHERE recYear = 2024;

-- Add check constraints to table in order to allow us to leverage partitioned views.
ALTER TABLE dbo.myDataTable
    ADD CONSTRAINT checkRecYear_current CHECK(recYear >= 2023)
;

ALTER TABLE dbo.myDataArchive
    ADD CONSTRAINT checkRecYear_archive CHECK(recYear < 2023)
;
GO

SELECT * FROM dbo.myDataView WHERE recYear = 2021;
SELECT * FROM dbo.myDataView WHERE recYear = 2024;

-- Now lets archive the data for 2023 to azure blob storage based table.
BEGIN TRANSACTION archiveData;

    ALTER TABLE dbo.myDataTable
        DROP CONSTRAINT checkRecYear_current
    ;

    ALTER TABLE dbo.myDataArchive
        DROP CONSTRAINT checkRecYear_archive
    ;

    INSERT INTO dbo.myDataArchive(recId, dataValue, recYear)
    SELECT recId, dataValue, recYear FROM dbo.myDataTable WHERE recYear IN (2023);

    DELETE FROM dbo.myDataTable WHERE recYear IN (2023);

    ALTER TABLE dbo.myDataTable
        ADD CONSTRAINT checkRecYear_current CHECK(recYear >= 2024)
    ;

    ALTER TABLE dbo.myDataArchive
        ADD CONSTRAINT checkRecYear_archive CHECK(recYear < 2024)
    ;
    
COMMIT TRANSACTION
GO

-- Enable actual execution plan collection in SSMS or ADS and then run the following queries to see where the data is served from when filtering by year.
SELECT * FROM dbo.myDataView WHERE recYear = 2023;
SELECT * FROM dbo.myDataView WHERE recYear = 2024;
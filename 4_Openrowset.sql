/* OPENROWSET */

/* Verify if 'Ad Hoc Distributed Queries' is enabled */

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

TRUNCATE TABLE dbo.TargetTable1;

SET STATISTICS TIME ON

CHECKPOINT

/* INSERT USING OPENROWSET AND BULK FUNCTION */

INSERT INTO dbo.TargetTable1 --3481094, 13415 pages
SELECT *
FROM OPENROWSET(
    BULK 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2022\MSSQL\SourceFile.csv',
    FORMAT='CSV',
    FIRSTROW=2
    
) 
WITH (
    Column1 INT,
    Column2 CHAR(1),
    Column3 FLOAT
) AS data;

/* VERIFY COUNT  */
SELECT COUNT(*) FROM dbo.TargetTable1;


SELECT Operation, COUNT(*) AS Count
FROM sys.fn_dblog(NULL, NULL) 
WHERE Operation IN (N'LOP_INSERT_ROWS', 'LOP_FORMAT_PAGE')
GROUP BY Operation
ORDER BY COUNT(*) DESC;




TRUNCATE TABLE dbo.TargetTable1;
CHECKPOINT


/* INSERT USING OPENROWSET AND BULK FUNCTION WITH TABLOCK */

INSERT INTO dbo.TargetTable1 WITH (TABLOCK) 
SELECT *
FROM OPENROWSET(
    BULK 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2022\MSSQL\SourceFile.csv',
   FORMAT='CSV',
    FIRSTROW=2    
) 
WITH (
    Column1 INT,
    Column2 CHAR(1),
    Column3 FLOAT
) 
AS data;

SELECT COUNT(*) FROM dbo.TargetTable1;


SELECT Operation, COUNT(*) AS Count
FROM sys.fn_dblog(NULL, NULL) 
WHERE Operation IN (N'LOP_INSERT_ROWS', 'LOP_FORMAT_PAGE')
GROUP BY Operation
ORDER BY COUNT(*) DESC;

TRUNCATE TABLE dbo.TargetTable1;


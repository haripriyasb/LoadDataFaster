
/* BULK INSERT */

TRUNCATE TABLE dbo.TargetTable1;

SET STATISTICS TIME ON

CHECKPOINT

BULK INSERT dbo.TargetTable1 
FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2022\MSSQL\SourceFile.csv'
WITH (
    FIELDTERMINATOR = ',',   -- for a comma-separated CSV
    ROWTERMINATOR = '\n',    -- rows end with newline
    FIRSTROW = 2             -- skip header row
);


SELECT Operation, COUNT(*) AS Count
FROM sys.fn_dblog(NULL, NULL) 
WHERE Operation IN (N'LOP_INSERT_ROWS', 'LOP_FORMAT_PAGE')
GROUP BY Operation
ORDER BY COUNT(*) DESC;

TRUNCATE TABLE dbo.TargetTable1;

CHECKPOINT

--Verify if log is clear
SELECT Operation, COUNT(*) AS Count
FROM sys.fn_dblog(NULL, NULL) 
WHERE Operation IN (N'LOP_INSERT_ROWS', 'LOP_FORMAT_PAGE')
GROUP BY Operation
ORDER BY COUNT(*) DESC;

--Add Tablock hint
BULK INSERT dbo.TargetTable1 
FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2022\MSSQL\SourceFile.csv'
WITH (
    FIELDTERMINATOR = ',',   -- for a comma-separated CSV
    ROWTERMINATOR = '\n',    -- rows end with newline
    FIRSTROW = 2 ,           -- skip header row
	TABLOCK                  -- tablock hint
);


SELECT Operation, COUNT(*) AS Count
FROM sys.fn_dblog(NULL, NULL) 
WHERE Operation IN (N'LOP_INSERT_ROWS', 'LOP_FORMAT_PAGE')
GROUP BY Operation
ORDER BY COUNT(*) DESC;
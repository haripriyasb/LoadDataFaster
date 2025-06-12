USE DBATEST
GO
DROP TABLE IF EXISTS dbo.t1
GO

SELECT t1.k AS id
	,'a_' + cast(t1.k AS VARCHAR) AS a
	,'b_' + cast(t1.k / 2 AS VARCHAR) AS b
INTO t1
FROM (
	SELECT ROW_NUMBER() OVER (
			ORDER BY a.object_id
			) AS k
	FROM sys.all_columns
		,sys.all_columns a
	) t1
WHERE t1.k < 1000001 

DROP TABLE IF EXISTS dbo.t2

SET STATISTICS TIME ON

SET NOCOUNT ON



SELECT id,a,b INTO dbo.t2 
FROM dbo.t1;

--------------------------------------------------------
-- VERIFY IF MINIMAL LOGGING OCCURRED
--------------------------------------------------------

/*
   ** Check the Transaction Log for Insert Behavior **
   ** 'LOP_INSERT_ROWS'  = Number of insert records tracked in T-Log
   ** 'LOP_FORMAT_PAGE'  = Number of pages formatted for this operation
*/

SELECT Operation, COUNT(*) AS Count
FROM sys.fn_dblog(NULL, NULL) 
WHERE Operation IN (N'LOP_INSERT_ROWS', 'LOP_FORMAT_PAGE')
GROUP BY Operation
ORDER BY COUNT(*) DESC;

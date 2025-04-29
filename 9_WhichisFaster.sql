/*

WHICH IS BETTER??

SELECT * INTO TARGETTABLE ..

OR 

INSERT INTO TARGETTABLE 

OR 

INSERT INTO TARGETTABLE WITH (TABLOCK)

*/



USE DBATEST
GO

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

DROP TABLE IF EXISTS dbo.#t2

SET STATISTICS TIME, IO ON

SET NOCOUNT ON

SELECT id,a,b INTO dbo.#t2 
FROM dbo.t1;


/*RESET TABLE AND LOG*/
TRUNCATE TABLE dbo.#t2
CHECKPOINT;


INSERT INTO #t2 WITH (TABLOCK)(id,a,b) 
SELECT * FROM t1


TRUNCATE TABLE dbo.#t2

INSERT INTO #t2 (id,a,b) 
SELECT * FROM t1

/*

SELECT * INTO           -> FAST RUN
INSERT INTO.. TABLOCK   -> FAST RUN
INSERT INTO             -> SLOW RUN

*/
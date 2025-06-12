
/* 

dbatools module 

Get source and target table ready  
Source table t1 - 1000 rows
Target table t2 - 0 rows

Move data using dbatools from t1 to t2

Which is Faster - Copy-DbaDbTableData or Write-DbaDbTableData ?

*/

USE DBATEST
GO
DROP TABLE IF EXISTS dbo.t1
GO
TRUNCATE TABLE dbo.t2;


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
WHERE t1.k < 1001 --Modify record count insertion as needed

--Verify count
SELECT COUNT(*) as t1_count FROM dbo.t1;

--Run below in Powershell dbatools

--Method 1: Copy-DbaDbTableData
Copy-DbaDbTableData -SqlInstance haripriya\sql2022 -Destination haripriya\sql2019 -Database dbatest -Table dbo.t1 #-AutoCreateTable

--Method 2: Write-DbaDbTableData
# Start timing
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# Read data from source
 $DataTable = Invoke-DbaQuery -SqlInstance haripriya\sql2022 -Database dbatest -Query "SELECT * FROM t1"

# Write data to target
 Write-DbaDbTableData -SqlInstance haripriya\sql2019  -InputObject $DataTable -Database dbatest -Table dbo.t1

# Stop timing
$sw.Stop()

# Get elapsed time
Write-Output "Elapsed time: $($sw.Elapsed.TotalSeconds) seconds"



/*

Which is Faster - Copy-DbaDbTableData or Write-DbaDbTableData ?

Copy-DbaDbTableData is faster because it does not buffer 
the contents of the data in the machine running the commands

*/


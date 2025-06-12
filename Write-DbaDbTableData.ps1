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
function Write-TempFile {
[CmdletBinding()]
param (
        [String]$Path = 'C:\MyAppLogs',
        [Int]$NumberofFiles = 10
        )

    If (-not (Test-Path -Path $Path)) { mkdir -Path $Path }

    1..$NumberofFiles | ForEach-Object {
        $File = New-TemporaryFile
        $New = Move-Item -Path $File -Destination $Path -PassThru -Force -Verbose
        $New.LastWriteTime = (Get-Date).AddDays( -$_ )
    }

    $Files = Get-ChildItem -Path $Path -Filter tmp* -File | Sort-Object -Property LastWriteTime
    $Newest = (New-TimeSpan ($Files | Select-Object -ExpandProperty LastWriteTime -Last 1)).TotalDays
    $Oldest = (New-TimeSpan ($Files | Select-Object -ExpandProperty LastWriteTime -First 1)).TotalDays

    Write-Warning "The newest Log file is $Newest days old"
    Write-Warning "The oldest Log file is $Oldest days old"
    Write-Warning "Sample Log Files Created in: $Path"
} 

Write-TempFile
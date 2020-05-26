break

#region Get-TargetResource code sample

	Write-Verbose "Searching for files older than $FileAgeDays days in $Path"

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    $LastWriteTime = (Get-Date).AddDays(-$FileAgeDays)

    $Files = Get-ChildItem -Path $Path -Filter tmp* -File
    $OldFiles = ($Files | Where-Object LastWriteTime -lt $LastWriteTime).FullName
    $NewFiles = ($Files | Where-Object LastWriteTime -ge $LastWriteTime).FullName

	$returnValue = @{
		Path = [System.String]$Path
		FileAgeDays = [System.Single]$FileAgeDays
		OldFiles = [System.String[]]$OldFiles
		NewFiles = [System.String[]]$NewFiles
	}

	$returnValue

#endregion Get


#region Set-TargetResource code sample

    $Current = Get-TargetResource -Path $Path -FileAgeDays $FileAgeDays
    
    if ($Current.OldFiles)
    {
        Write-Verbose "Removing files older than $FileAgeDays days: $($Current.OldFiles)"
        $Current.OldFiles | Remove-Item -Verbose
    }

#endregion Set


#region Test-TargetResource code sample

	$Current = Get-TargetResource -Path $Path -FileAgeDays $FileAgeDays
    
    if ($Current.OldFiles.count -ge 1)
    {
        Write-Verbose "$($Current.OldFiles.count) files older than $FileAgeDays days: $($Current.OldFiles)"
        $False
    }
    else
    {
        Write-Verbose "$($Current.OldFiles.count) files older than $FileAgeDays days."
        $True
    }

#endregion Test

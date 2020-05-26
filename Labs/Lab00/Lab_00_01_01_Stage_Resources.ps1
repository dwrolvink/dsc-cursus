
#region EXTRACT RESOURCES #####################################################

# PSv5 includes Expand-Archive & Compress-Archive
# PSv4 does not include these
# Use this sample code to extract the module ZIP on PSv4
# http://powershell.com/cs/blogs/tips/archive/2015/07/30/unzipping-zip-files-with-any-powershell-version.aspx
Function unZip {
Param (
    $Source = 'C:\somezipfile.zip', 
    $Destination = 'C:\somefolder'
)
 
    if ((Test-Path $Destination) -eq $false) 
    {
      $null = mkdir $Destination 
    }
 
    $shell = New-Object -ComObject Shell.Application 
    $sourceFolder = $shell.NameSpace($Source)
    $destinationFolder = $shell.NameSpace($Destination)
    $DestinationFolder.CopyHere($sourceFolder.Items(),16)
}

$src  = 'C:\PShell\DSC Resource Kit Wave 10 04012015.zip\All Resources'
$dest = "$Env:ProgramFiles\WindowsPowerShell\Modules"
unZip -Source "$src\xWindowsUpdate" -Destination "$dest\xWindowsUpdate"
unZip -Source "$src\xPendingReboot" -Destination "$dest\xPendingReboot"

#endregion ####################################################################



#region SHARE RESOURCES #######################################################

# Share out the source
New-SmbShare -ReadAccess Everyone -Path C:\PShell -Name PShell

# Enable firewall rule for smb
Set-NetFirewallRule -CimSession ms1,ms2 -DisplayGroup "File and Printer Sharing" -Profile Domain -Enabled True 

# Manually push the resource modules to the nodes
'MS1','MS2' | % {
    Copy-Item "$Env:ProgramFiles\WindowsPowerShell\Modules\x*" "\\$_\c$\Program Files\WindowsPowerShell\Modules\" -Recurse -Force
}

#endregion ####################################################################

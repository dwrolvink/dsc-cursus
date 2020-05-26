break

#region INSTRUCTIONS ##########################################################

# Select each region of code below and then use RunSelection (F8)

# Selection tip:
# - Click once on the blank line above the region
# - Scroll to the end of the region
# - Hold SHIFT and click the blank line after the region
# - This should select all the text between the two clicks.

#endregion ####################################################################



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

# Working folder
Set-Location $Env:USERPROFILE\Documents

# Share out the source
New-SmbShare -ReadAccess Everyone -Path C:\PShell -Name PShell

# Enable firewall rule for smb
Set-NetFirewallRule -CimSession ms1,ms2 -DisplayGroup "File and Printer Sharing" -Profile Domain -Enabled True 

# Manually push the resource modules to the nodes
'MS1','MS2' | % {
    Copy-Item "$Env:ProgramFiles\WindowsPowerShell\Modules\x*" "\\$_\c$\Program Files\WindowsPowerShell\Modules\" -Recurse -Force
}

#endregion ####################################################################



#region PUSH WMF 5 CONFIGURATION ##############################################

# Configuration to install WMF5
Configuration InstallWMF5
{
    Import-DscResource -Module PSDesiredStateConfiguration, xWindowsUpdate, xPendingReboot

    Node ('MS1','MS2','PULL')
    {

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            RefreshMode        = 'PUSH'
        }

        File TempDir
        {
            DestinationPath = 'C:\Temp'
            Force           = $True
            Ensure          = 'Present'
            Type            = 'Directory'
        }

        File WMF5Source
        {
            DestinationPath = 'C:\Temp\Win8.1AndW2K12R2-KB3134758-x64.msu'
            Ensure          = 'Present'
            SourcePath      = '\\PULL\PShell\WMF5\Win8.1AndW2K12R2-KB3134758-x64.msu'
            Type            = 'File'
            Force           = $True
            DependsOn       = '[File]TempDir'
        }

        xHotFix WMF5Install
        {
            Id        = 'KB3134758'
            Ensure    = 'Present'
            Path      = 'C:\Temp\Win8.1AndW2K12R2-KB3134758-x64.msu'
            DependsOn = '[File]WMF5Source'
        }

        # xHotFix should trigger a reboot to DSC, but it doesn't yet.
        xPendingReboot WMF5Reboot
        {
            Name      = 'RebootMe'
            DependsOn = '[xHotFix]WMF5Install'
        }
    }
}

Set-Location C:\PShell\Labs\Lab01\

# Generate the MOFs
InstallWMF5
#endregion ####################################################################



#region PUSH META CONFIGURATION ###############################################
# Configure the LCMs
Set-DscLocalConfigurationManager -Path .\InstallWMF5 -Verbose
#endregion ####################################################################



#region PUSH WMF 5 CONFIGURATION TO MS1 AND MS2 ###############################
# Apply the configurations to the remote nodes first and reboot
Start-DscConfiguration -Path .\InstallWMF5 -ComputerName MS1,MS2 -Wait -Verbose -Force
#endregion ####################################################################



#region PUSH WMF 5 CONFIGURATION TO PULL ######################################
# Apply and reboot this server last
Start-DscConfiguration -Path .\InstallWMF5 -ComputerName PULL -Wait -Verbose -Force

#endregion ####################################################################



#region CLEAN UP WMF 4.0 DSC ##################################################
# Open this file after the reboot of PULL and run this last section
Invoke-Command -ComputerName MS1,MS2,PULL -ScriptBlock {
    del C:\windows\system32\configuration\*.mof
    del 'C:\Program Files\WindowsPowerShell\Modules\[xc]*' -Recurse -Force
}

#endregion ####################################################################

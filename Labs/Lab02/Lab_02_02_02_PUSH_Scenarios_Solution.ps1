break

#region Task 2.2.2

Get-Command -Module PSDesiredStateConfiguration 

Help Start-DscConfiguration -Full

Start-DscConfiguration -Path .\JumpServer -Wait -Verbose

Get-WindowsFeature -Name RSAT*

Get-DscResource -Name WindowsFeature -Syntax


configuration JumpServer
{
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    node LocalHost
    {
        WindowsFeature FileServices
        {
           Ensure               = "Present"
           Name                 = "RSAT-File-Services"
           LogPath              = 'c:\windowsfeatureinstall.log'
           IncludeAllSubFeature = $true
        }      
    }
}

JumpServer
Start-DscConfiguration -Path .\JumpServer

Get-Job

Test-Path -path C:\windowsfeatureinstall.log
Get-Content -path C:\windowsfeatureinstall.log
Remove-Item -path C:\windowsfeatureinstall.log

Get-Job | Receive-Job

Get-Job | Remove-Job

Start-DscConfiguration -Path .\JumpServer -wait -Verbose

Test-DscConfiguration

Test-DscConfiguration -Detailed

Get-WindowsFeature -Name RSAT*

Get-DscConfiguration

Get-DscConfigurationStatus

Get-DscConfigurationStatus -All

#endregion


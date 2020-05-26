set-location C:\PShell\Labs\Lab02
Get-WindowsFeature -name Rsat*


configuration JumpServer
{
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node localhost
    {
        # Call Resource Provider
        # E.g: WindowsFeature, File
        WindowsFeature FileServices
        {
           Ensure = "Absent"
           Name   = "RSAT-File-Services"
           LogPath = 'C:\windowsfeatureinstall.log'
           DependsOn = '[File]LogDir'
        }

        File LogDir {
            DestinationPath = 'C:\Logs'
            Type = 'Directory'
            Ensure = 'Present'
        }
    }
}

JumpServer

Start-DscConfiguration -Path .\JumpServer -wait -Verbose -Force

Get-DscResource -Name WindowsFeature -Syntax


get-job | Receive-Job -Keep -Verbose
Get-Job | Remove-Job

Test-Path -Path C:\windowsfeatureinstall.log

Test-DscConfiguration -detailed

Get-DscConfigurationStatus -All

Restore-DscConfiguration -Verbose

get-childitem -Path C:\Windows\System32\Configuration -Filter *.mof

Get-DscLocalConfigurationManager

Remove-DscConfigurationDocument -Stage Current -Verbose
Remove-DscConfigurationDocument -Stage Previous -Verbose
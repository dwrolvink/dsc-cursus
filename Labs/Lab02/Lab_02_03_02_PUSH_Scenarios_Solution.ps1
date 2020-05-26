break

#region Task 2.3.2

configuration JumpServer
{
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node LocalHost
    {
        WindowsFeature FileServices
        {
           Ensure = 'Absent'
           Name = "RSAT-File-Services"
           LogPath = 'C:\Logs\windowsfeatureinstall.log'
           DependsOn = '[File]LogDir'
        }  
        
        File LogDir
        {
            DestinationPath = 'C:\Logs'
            Type = 'Directory'
            Ensure = 'Present'
        }    
    }
}

JumpServer
Start-DscConfiguration -Path .\JumpServer -Verbose -Wait

Get-ChildItem -Path C:\Windows\System32\Configuration -Filter *.mof

Get-DscLocalConfigurationManager

Start-DscConfiguration -Path .\JumpServer -Verbose -Wait -Force

Get-ChildItem -Path C:\Logs
Get-WindowsFeature -Name RSAT*

Test-DscConfiguration -Detailed

Get-Command -Module PSDesiredStateConfiguration

Remove-DscConfigurationDocument -Stage Current -Verbose
Remove-DscConfigurationDocument -Stage Previous -Verbose

Get-ChildItem -Path C:\Windows\System32\Configuration -Filter *.mof

Get-DscLocalConfigurationManager

Remove-Item -Path C:\Logs -Recurse

#Endregion

break

#region Task 2.2.3

configuration JumpServer
{
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node LocalHost
    {

        WindowsFeature FileServices
        {
           Ensure = 'Absent'
           Name = "RSAT-File-Services"
           LogPath = 'c:\windowsfeatureinstall.log'
        }    
    }
}

JumpServer
Start-DscConfiguration -Path .\JumpServer -Verbose -Wait

Get-WindowsFeature -Name RSAT*

Get-ChildItem -Path C:\Windows\System32\Configuration -Filter *.mof

psedit C:\Windows\System32\Configuration\Current.mof
psedit C:\Windows\System32\Configuration\Previous.mof

Get-Command -module PSDesiredStateConfiguration

Restore-DscConfiguration -Verbose

Get-WindowsFeature -Name RSAT*

Remove-Item -Path c:\windowsfeatureinstall.log

#endregion

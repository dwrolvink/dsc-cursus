Break

# Task 2.4.2

#region 1

Configuration BaselineConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    Node ('MS1','MS2')
    {
        WindowsFeature RemoveTelnetServer
        {
            Name = 'Telnet-Server'
            Ensure = 'Absent'
        }
    }
}

Set-Location -Path C:\PShell\Labs\Lab02
BaselineConfig

#endregion 1

#region 2

Start-DscConfiguration -Path .\BaselineConfig -Verbose -Wait

#endregion 2

break

#region Task 2.3.1

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
           DependsOn = '[File]LogDir'
        }  
        
        File LogDir
        {
            DestinationPath = 'H:\Logs'
            Type = 'Directory'
            Ensure = 'Present'
        }    
    }
}

JumpServer
Start-DscConfiguration -Path .\JumpServer -Verbose -Wait

Get-DscConfiguration

Test-DscConfiguration -Detailed

#endregion

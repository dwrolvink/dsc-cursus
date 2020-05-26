Configuration JumpServer_3
{
Param(
    [string[]]$ComputerName = $Env:COMPUTERNAME

)
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xRemoteDesktopAdmin, xNetworking

    Node $ComputerName
    {









        xRemoteDesktopAdmin RemoteDesktopSettings
        {
           Ensure = 'Present'
           UserAuthentication = 'Secure'
        }

        xFirewall AllowRDP
        {
            Name = 'DSC - Remote Desktop Admin Connections'
            Group = "Remote Desktop"
            Ensure = 'Present'
            Enabled = $true
            Action = 'Allow'
            Profile = 'Domain'
        }
    }
}

cd C:\PShell\Labs\Lab08

JumpServer_3 -ComputerName ms2

psEdit .\JumpServer_3\ms2.mof

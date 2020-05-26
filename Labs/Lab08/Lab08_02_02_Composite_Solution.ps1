Configuration compositeEnableRDP
{
    Import-DscResource -ModuleName xRemoteDesktopAdmin, xNetworking

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

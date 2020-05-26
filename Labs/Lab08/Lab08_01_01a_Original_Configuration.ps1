Configuration JumpServer_1
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xRemoteDesktopAdmin, xNetworking

    Node ms2
    {
        WindowsFeature WebConsole
        {
            Name = 'Web-Mgmt-Console'
            IncludeAllSubFeature = $true
            Ensure = 'Present'
        }

        WindowsFeature WebScripting
        {
            Name = 'Web-Scripting-Tools'
            IncludeAllSubFeature = $true
            Ensure = 'Present'
        }

        WindowsFeature ActiveDirectory
        {
            Name = 'RSAT-AD-Tools'
            IncludeAllSubFeature = $true
            Ensure = 'Present'
        }

        WindowsFeature DNS
        {
            Name = 'RSAT-DNS-Server'
            IncludeAllSubFeature = $true
            Ensure = 'Present'
        }

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

JumpServer_1

psEdit .\JumpServer_1\ms2.mof

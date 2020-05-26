cd C:\PShell\Labs\Lab05

[DscLocalConfigurationManager()]
Configuration LCMPush
{
    Node ms1
    {
        Settings
        {
            RefreshMode = 'Push'
        }
    }
}

LCMPush
Set-DscLocalConfigurationManager -Path .\LCMPush -Verbose

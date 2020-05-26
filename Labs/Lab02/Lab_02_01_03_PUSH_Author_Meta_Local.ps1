Break

# Task 2.1.3

#region 1

Get-DscLocalConfigurationManager

#endregion 1

#region 2

[DscLocalConfigurationManager()]
Configuration LCMPushDisableReboot
{
    Node localhost
    {
        Settings
        {
            ActionAfterReboot  = 'ContinueConfiguration'
            ConfigurationMode  = 'ApplyAndAutoCorrect'
            RebootNodeIfNeeded = $False
            RefreshMode        = 'Push'
        }
    }
}

Set-Location -Path C:\PShell\Labs\Lab02
LCMPushDisableReboot

#endregion 2



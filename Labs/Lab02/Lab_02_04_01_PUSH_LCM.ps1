Break

# Task 2.4.1

#region 1

Get-DscLocalConfigurationManager -CimSession MS1

#endregion 1

#region 2

[DscLocalConfigurationManager()]
Configuration LCMPushDisableReboot
{
    Node ('MS1','MS2')
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

#region 3

Set-DSCLocalConfigurationManager -Path .\LCMPushDisableReboot -Verbose

#endregion 3

#region 4

$CS = New-CimSession -ComputerName MS1,MS2
Get-DscLocalConfigurationManager -CimSession $CS

#endregion 4

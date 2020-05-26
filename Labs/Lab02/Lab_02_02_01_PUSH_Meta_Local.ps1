Break

# Task 2.2.1

#region 1

Get-DscLocalConfigurationManager

#endregion 1

#region 2

# This was created in the previous Task 2.1.3
Get-ChildItem -Path .\LCMPushDisableReboot

#endregion 2

#region 3

Set-DSCLocalConfigurationManager -Path .\LCMPushDisableReboot -Verbose

#endregion 3

#region 4

Get-DscLocalConfigurationManager

#endregion 4

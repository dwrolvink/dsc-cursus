Install-Module xDscDiagnostics -Force


Get-Command -Module xDscDiagnostics
Get-Command Get-xDscOperation -Syntax
Get-Command Trace-xDscOperation -Syntax
Get-Command Update-xDscEventLogStatus -Syntax


'Analytic','Debug' | ForEach-Object {
    Update-xDscEventLogStatus -Channel $_ -Status Enabled -ComputerName ms1
}


& C:\PShell\Labs\Lab07\Lab_07_02_02_Configuration_Error.ps1


Get-xDscOperation -ComputerName ms1 -Newest 10

Trace-xDscOperation -ComputerName ms1 -JobId 'paste here' | Out-GridView


Get-DscConfigurationStatus -CimSession ms1 -All | Select-Object Status, StartDate, Type, Mode, JobId -First 10 | Format-Table -AutoSize

Get-xDscOperation -ComputerName ms1 -Newest 10


Get-DscConfigurationStatus -CimSession ms1 -All | Where-Object {$_.Type -eq 'Initial' -and $_.Status -eq 'Failure'} | Select-Object * -First 1

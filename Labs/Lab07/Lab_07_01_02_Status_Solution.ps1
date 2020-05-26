break

Get-DscConfigurationStatus

Get-DscConfigurationStatus | Format-List *

Test-DscConfiguration -Detailed


Get-DscConfigurationStatus -CimSession pull,ms1,ms2 | Select-Object * | Out-GridView

Test-DscConfiguration -Detailed -CimSession pull,ms1,ms2 | Select-Object * | Out-GridView


Get-DscLocalConfigurationManager


dir C:\Windows\System32\Configuration\ConfigurationStatus | Sort-Object LastWriteTime

Get-Content (dir C:\Windows\System32\Configuration\ConfigurationStatus | Sort-Object LastWriteTime -Descending)[0].FullName -Encoding Unicode

Get-Content C:\Windows\System32\Configuration\DSCStatusHistory.mof -Encoding Unicode


Get-DscConfigurationStatus -All | Out-GridView

Get-DscConfigurationStatus -All | Where-Object {$_.Status -ne 'Success'} | Select-Object * | Out-GridView


Get-DscConfigurationStatus -All -CimSession pull,ms1,ms2 | Where-Object {$_.Status -ne 'Success'} | Select-Object * | Out-GridView

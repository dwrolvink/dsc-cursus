update-help -verbose
get-help *Desired*
start-process https://msdn.microsoft.com/en-us/PowerShell/DSC/overview

get-module -name ps* -listavailable
get-command -module PSDesiredStateConfiguration
Get-Command -Module PSDesiredStateConfiguration | ForEach-Object Name | Out-File -FilePath c:\pshell\V4Cmdlets.txt

Get-DscLocalConfigurationManager
Get-DscLocalConfigurationManager -CimSession MS1

Get-DscResource

Invoke-Command -ComputerName ms1,ms2,pull -ScriptBlock {$PSVersionTable.PSVersion}

update-help -Verbose

Get-Command -Module PSDesiredStateConfiguration | ForEach-Object Name | Out-File -FilePath c:\pshell\V5Cmdlets.txt

$V4 = Get-Content -Path c:\pshell\V4Cmdlets.txt

$V5 = Get-Content -Path c:\pshell\V5Cmdlets.txt

 
Compare-Object -ReferenceObject $v4 -DifferenceObject $v5 -IncludeEqual
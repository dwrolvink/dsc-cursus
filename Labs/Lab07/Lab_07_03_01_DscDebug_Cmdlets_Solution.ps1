break

Get-Command -Noun DscDebug


Get-Command Enable-DscDebug -Syntax


Invoke-Command -ComputerName ms1 -ScriptBlock {
    Remove-Item C:\Windows\System32\Configuration\*.mof -Force
}


$cim = New-CimSession -ComputerName ms1
Enable-DscDebug -BreakAll -CimSession $cim


Get-DscLocalConfigurationManager -CimSession $cim

break

Get-DscLocalConfigurationManager | Select-Object LCMState, LCMStateDetail

Stop-DscConfiguration -Verbose

Stop-DscConfiguration -Verbose -Force

Get-DscLocalConfigurationManager -CimSession pull,ms1,ms2 |
    Format-Table PSComputerName, LCMState, LCMStateDetail

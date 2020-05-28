cd C:\PShell\Labs\Lab07\

psedit C:\PShell\Labs\Lab07\Lab_07_01_01a_LCM_State.ps1

psedit C:\PShell\Labs\Lab07\Lab_07_01_02_Status_Solution.ps1

psedit C:\PShell\Labs\Lab07\Lab_07_02_01_GetWinEvent_Solution.ps1

psedit C:\PShell\Labs\Lab07\Lab_07_02_02_xDscDiagnostics_Solution.ps1

Invoke-Command -ComputerName ms1 -ScriptBlock { Remove-Item C:\Windows\System32\Configuration\*.mof -Force }
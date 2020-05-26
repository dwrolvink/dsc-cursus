
Invoke-Command -ComputerName pull,ms1,ms2 -ScriptBlock {
    Set-NetFirewallRule -DisplayGroup 'Remote Event Log Management' -Enabled True
}


Get-WinEvent -ListLog *dsc*,*desired* -Force | Out-GridView


Get-WinEvent -LogName Microsoft-Windows-DSC/Operational -MaxEvents 50 | Out-GridView


Update-DscConfiguration -Wait -Verbose -ComputerName ms1

Enter-PSSession -ComputerName ms1

Get-Content C:\Windows\System32\Configuration\Current.mof

net localgroup AppServiceGroup

Get-DscConfiguration

Exit-PSSession

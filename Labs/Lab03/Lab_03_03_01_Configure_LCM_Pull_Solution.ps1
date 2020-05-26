[DscLocalConfigurationManager()]
Configuration MS1Meta
{
param (
    [String]$GUID = (Get-Content -Path c:\pshell\labs\lab03\ms1guid.txt)
)
    Node MS1
    {
        Settings
        {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            ConfigurationID   = $Guid
            RefreshMode       = "Pull"

        }

        ConfigurationRepositoryWeb PULL
        {
            ServerURL = "http://PULL:8080/PSDSCPullServer.svc"
            AllowUnsecureConnection = $True
        }
    }
}

Set-Location -Path C:\PShell\Labs\Lab03
MS1Meta

Get-DscLocalConfigurationManager -CimSession ms1
Set-DscLocalConfigurationManager -Path .\MS1Meta -Verbose
Get-DscLocalConfigurationManager -CimSession ms1

Invoke-Command -ComputerName ms1 -ScriptBlock { Get-ChildItem -Path C:\Windows\System32\Configuration }

Update-DscConfiguration -CimSession ms1 -Wait -Verbose

Start-Process http://ms1/

& $ENV:Windir\System32\Inetsrv\InetMgr.exe

Start-DscConfiguration -CimSession ms1 -Wait -Verbose -UseExisting


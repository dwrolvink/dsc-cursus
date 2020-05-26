Configuration BaseConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node ms1
    {
        Archive WebFiles
        {
            Ensure      = 'Present'
            Path        = '\\PULL\PShell\Labs\Lab03\Lab_03_03_02_WebSite3_2.zip'
            Destination = 'C:\inetpub\wwwroot\'
            Force       = $true
            Validate    = $true
            Checksum    = 'SHA-1'
        }

        WindowsFeature WebServer
        {
            Name      = 'Web-Server'
            Ensure    = 'Present'
            DependsOn = '[Archive]WebFiles'
        }

        WindowsFeature WebMgmtService # Enable remote Web Management
        {
            Name      = 'Web-Mgmt-Service'
            Ensure    = 'Present'
            DependsOn = '[Archive]WebFiles'
        }       
        
        Registry EnableRemoteManagement # Enable remote Web Management
        {
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WebManagement\Server'
            ValueName = 'EnableRemoteManagement'
            Ensure    = 'Present'
            ValueData = 1
            ValueType = 'Dword'
            DependsOn = '[WindowsFeature]WebMgmtService'
        } 
        
        Service WMSVC #Web Management Service
        {
            Name        = 'WMSVC'
            StartupType = 'Manual'
            State       = 'Running'
            DependsOn   = '[Registry]EnableRemoteManagement'
        }             
    }
}

Set-Location C:\PShell\Labs\Lab03

BaseConfig


$GUID = (Get-Content -Path c:\pshell\labs\lab03\ms1guid.txt)

$destination = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\$GUID.mof"

Copy-Item -Path .\BaseConfig\MS1.mof -Destination $destination -PassThru

New-DscChecksum -Path $destination -Force -Verbose

Update-DscConfiguration -CimSession ms1 -Wait -Verbose

Start-Process http://ms1/

Configuration BaseConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node ms1
    {
        Archive WebFiles
        {
            Ensure      = 'Present'
            Path        = '\\PULL\PShell\Labs\Lab03\Lab_03_02_01_WebSite3_1.zip'
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

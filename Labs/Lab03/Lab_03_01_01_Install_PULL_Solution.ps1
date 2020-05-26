Get-DscResource -Name xDSCWebService -Syntax
Set-Location (Get-Module -Name xPSDesiredStateConfiguration -ListAvailable).ModuleBase
dir
cd .\Examples
dir
psEdit .\Sample_xDscWebService.ps1


configuration PullServerHTTP
{

    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node localhost
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"            
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                   = "Present"
            EndpointName             = "PSDSCPullServer"
            Port                     = 8080
            PhysicalPath             = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint    = "AllowUnencryptedTraffic"
            ModulePath               = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath        = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"            
            State                    = "Started"
            UseSecurityBestPractices =             $false
            DependsOn                = "[WindowsFeature]DSCServiceFeature" 
            
        }


        
    }
}

Set-Location C:\PShell\Labs\Lab03
PullServerHTTP
Start-DscConfiguration -Path .\PullServerHTTP -Verbose -Wait

Start-Process http://PULL:8080/PSDSCPullServer.svc

& $ENV:Windir\System32\Inetsrv\InetMgr.exe

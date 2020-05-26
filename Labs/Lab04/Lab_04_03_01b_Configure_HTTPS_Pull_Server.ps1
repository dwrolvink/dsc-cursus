Configuration CreateHTTPSPullServer
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration,xPSDesiredStateConfiguration

    Node localhost 
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"
        }
        xDscWebService PSDSCPullServer
        {
            Ensure                  = 'Present'
            EndpointName            = 'PSDSCPullServer'
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbPrint   = ''
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                   = 'Started'
            UseSecurityBestPractices = $true
            DisableSecurityBestPractices = 'SecureTLSProtocols'
            DependsOn               = '[WindowsFeature]DSCServiceFeature'
            
        }
        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = '55e3f8b-2949-4c73-9549-442aa1969dd7'
        }
        WindowsFeature IISMgmtGui
        {
            Ensure = "Present"
            Name   = "Web-Mgmt-Console"
            DependsOn = '[xDscWebService]PSDSCPullServer'
        }
        WindowsFeature IISScripting
        {
            Ensure = "Present"
            Name   = "Web-Scripting-Tools"
            DependsOn = '[xDscWebService]PSDSCPullServer'
        }
    }
} 

CreateHTTPSPullServer
Start-DscConfiguration -Path .\CreateHTTPSPullServer -Wait -Verbose -Force

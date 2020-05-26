Set-Location C:\PShell\Labs\Lab00


#region CERT TEMPLATE PERMISSIONS #############################################

<#
Add Domain Computers with Enroll permission on the Web Server CS template.

ActiveDirectoryRights : ExtendedRight
InheritanceType       : None
ObjectType            : 0e10c968-78fb-11d2-90d4-00c04f79dc55
InheritedObjectType   : 00000000-0000-0000-0000-000000000000
ObjectFlags           : ObjectAceTypePresent
AccessControlType     : Allow
IdentityReference     : CONTOSO\Domain Computers
IsInherited           : False
InheritanceFlags      : None
PropagationFlags      : None
#>

Import-Module ActiveDirectory

$TemplatePath        = 'AD:\CN=WebServer,CN=Certificate Templates,CN=Public Key Services,CN=Services,CN=Configuration,DC=contoso,DC=com'
$acl                 = Get-ACL $TemplatePath
$account             = New-Object System.Security.Principal.NTAccount('CONTOSO\Domain Computers')
$sid                 = $account.Translate([System.Security.Principal.SecurityIdentifier])
$ObjectType          = [GUID]'0e10c968-78fb-11d2-90d4-00c04f79dc55'
$InheritedObjectType = [GUID]'00000000-0000-0000-0000-000000000000'
$ace                 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule `
    $sid, 'ExtendedRight', 'Allow', $ObjectType, 'None', $InheritedObjectType
$acl.AddAccessRule($ace)
Set-ACL $TemplatePath -AclObject $acl

#endregion ####################################################################



#region CERT REQUEST/INSTALL ##################################################

$Req = @{
    Template          = 'WebServer'
    DnsName           = 'pull.contoso.com'
    SubjectName       = 'CN=pull.contoso.com'
    Url               = 'ldap:'
    CertStoreLocation = 'Cert:\LocalMachine\My'
}
$cert = Get-Certificate @Req
$thumbprint = $cert.Certificate.Thumbprint

#endregion ####################################################################



#region HTTPS CONFIG ##########################################################

# Thumbprint goes into CertificateThumbPrint below
Configuration CreateHTTPSPullServer
{
Param(
    # Note that this will only work for the local server
    $SSLThumbprint = (Get-ChildItem Cert:\LocalMachine\My -SSLServerAuthentication | Where-Object Subject -eq 'CN=pull.contoso.com').Thumbprint
)

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
            Ensure                   = 'Present'
            EndpointName             = 'PSDSCPullServer'
            Port                     = 8080
            PhysicalPath             = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbPrint    = $SSLThumbprint
            ModulePath               = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath        = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                    = 'Started'
            UseSecurityBestPractices = $false
            DependsOn                = '[WindowsFeature]DSCServiceFeature'
        }
        WindowsFeature IISMgmtGui
        {
            Ensure    = "Present"
            Name      = "Web-Mgmt-Console"
            DependsOn = '[xDscWebService]PSDSCPullServer'
        }
        WindowsFeature IISScripting
        {
            Ensure    = "Present"
            Name      = "Web-Scripting-Tools"
            DependsOn = '[xDscWebService]PSDSCPullServer'
        }
    }
} 

cd C:\PShell\Labs\Lab00
CreateHTTPSPullServer -SSLThumbprint $thumbprint
Start-DscConfiguration -Path .\CreateHTTPSPullServer -Wait -Verbose -Force

#endregion ####################################################################


#region CONFIRM ###############################################################

# Test HTTPS pull server
Start-Process "https://pull.contoso.com:8080/PSDSCPullServer.svc"

#endregion ####################################################################

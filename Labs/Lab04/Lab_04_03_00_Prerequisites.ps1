#Requires -RunAsAdministrator

#region INSTALL RESOURCES #####################################################

# Use the latest copy of the module
Remove-Item 'C:\Program Files\WindowsPowerShell\Modules\xPSDesiredStateConfiguration' -Recurse -Force -Confirm:$false -Verbose
Install-Module xPSDesiredStateConfiguration -Force -Verbose

#endregion ####################################################################


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

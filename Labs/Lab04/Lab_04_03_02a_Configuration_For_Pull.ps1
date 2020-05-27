Configuration EncryptedPull
{
Param(
    [PSCredential]$Credential
)
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        User LocalUser
        {
            UserName = 'AppServiceAccount'
            FullName = 'Special Application Service Account'
            Password = $Credential
            Ensure   = 'Present'
        }

        Group LocalGroup
        {
            GroupName        = 'AppServiceGroup'
            MembersToInclude = 'AppServiceAccount'
            Ensure           = 'Present'
            DependsOn        = '[User]LocalUser'
        }

    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'ms1'
            CertificateFile = 'C:\PublicKeys\MS1.cer'
            Thumbprint = '1BF559A578CE95F70457066CB20EC9D95C7486CC'
        }
    )
}

cd C:\PShell\Labs\Lab04

$Cred = Get-Credential -Message 'Complex password for service account' -UserName 'Enter password only'
EncryptedPull -Credential $Cred -ConfigurationData $ConfigData

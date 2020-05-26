Configuration EncryptedPassword
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

        LocalConfigurationManager
        {
            CertificateID = ''
        }

    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'ms1'
            CertificateFile = ''
            Thumbprint = ''
        }
    )
}

$Cred = Get-Credential -Message 'Complex password for service account' -UserName 'Enter password only'
EncryptedPassword -Credential $Cred -ConfigurationData $ConfigData

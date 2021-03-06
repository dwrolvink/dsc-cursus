﻿Configuration EncryptedPassword
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
            CertificateID = $Node.Thumbprint
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

$Cred = Get-Credential -Message 'Complex password for service account' -UserName 'Enter password only'
EncryptedPassword -Credential $Cred -ConfigurationData $ConfigData

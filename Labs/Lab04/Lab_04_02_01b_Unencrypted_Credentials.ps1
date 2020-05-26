Configuration ClearTextPassword
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
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'

        }
    )
}

$Cred = Get-Credential -Message 'Password for service account' -UserName 'Enter password only'
ClearTextPassword -Credential $Cred -ConfigurationData $ConfigData

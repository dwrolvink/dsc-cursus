Configuration ClearTextPassword
{
Param(
    [PSCredential]$Credential
)
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost
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

$Cred = Get-Credential -Message 'Password for service account' -UserName 'Enter password only'
ClearTextPassword -Credential $Cred

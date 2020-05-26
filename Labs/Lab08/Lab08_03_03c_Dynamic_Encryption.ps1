#region CONFIGURATION WITH CREDENTIAL #########################################

Configuration EnableRDP
{
Param(
    [pscredential]$Credential
)
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xRemoteDesktopAdmin, xNetworking

    Node $AllNodes.NodeName
    {
        xRemoteDesktopAdmin RemoteDesktopSettings
        {
           Ensure = 'Present'
           UserAuthentication = 'Secure'
        }

        xFirewall AllowRDP
        {
            Name = 'DSC - Remote Desktop Admin Connections'
            Group = "Remote Desktop"
            Ensure = 'Present'
            Enabled = $true
            Action = 'Allow'
            Profile = 'Domain'
        }

        Group RDPGroup
        {
            Ensure = 'Present'
            GroupName = 'Remote Desktop Users'
            Members = 'contoso\ericlang'
            Credential = $Credential
        }

    }
}

#endregion ####################################################################



#region LCM ###################################################################

[DscLocalConfigurationManager()]
Configuration LCMDecrypt
{
    Node $AllNodes.NodeName
    {
        Settings
        {
            CertificateID = $Node.Thumbprint
            RefreshMode   = 'Push'
        }
    }
}

#endregion ####################################################################



#region DYNAMIC CONFIGURATION DATA ############################################

$nodes = Import-Csv C:\PublicKeys\index.csv

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "*"
            PSDscAllowDomainUser = $true
        }
    )
}

ForEach ($node in $nodes) {
    $ConfigData.AllNodes += @{
        NodeName        = $node.Node
        CertificateFile = $node.Path
        Thumbprint      = $node.Thumbprint
    }
}

#endregion ####################################################################



#region GENERATE MOF AND META.MOF #############################################

cd C:\PShell\Labs\Lab08

EnableRDP  -ConfigurationData $ConfigData -Credential (Get-Credential -UserName 'CONTOSO\Administrator' -Message 'Enter the password')
LCMDecrypt -ConfigurationData $ConfigData

Get-ChildItem .\EnableRDP\*.mof  | ForEach-Object {psEdit $_.FullName}
Get-ChildItem .\LCMDecrypt\*.mof | ForEach-Object {psEdit $_.FullName}

#endregion ####################################################################

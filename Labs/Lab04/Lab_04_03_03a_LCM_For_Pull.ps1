[DscLocalConfigurationManager()]
Configuration HTTPS_Pull
{
    Node $AllNodes.NodeName
    {
        Settings
        {
            ConfigurationID = $node.ConfigurationID
            CertificateId   = $node.Thumbprint
            RefreshMode     = 'Pull'
        }
        ConfigurationRepositoryWeb PullServer
        {
            ServerUrl = ''
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName        = 'ms1'
            CertificateFile = 'C:\PublicKeys\MS1.cer'
            Thumbprint      = '1D1FB28E22FB2410291291D47ED45DD2BA725A33'
            ConfigurationID = ''
        }
    )
}

cd C:\PShell\Labs\Lab04

HTTPS_Pull -ConfigurationData $ConfigData

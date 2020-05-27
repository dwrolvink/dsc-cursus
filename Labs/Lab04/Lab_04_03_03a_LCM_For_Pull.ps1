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
            ServerUrl = 'https://pull.contoso.com:8080/PSDSCPullServer.svc'
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName        = 'ms1'
            CertificateFile = 'C:\PublicKeys\MS1.cer'
            Thumbprint      = '1BF559A578CE95F70457066CB20EC9D95C7486CC'
            ConfigurationID = 'fd52b8a8-3052-44d1-a949-206cf253aafa'
        }
    )
}

cd C:\PShell\Labs\Lab04

HTTPS_Pull -ConfigurationData $ConfigData

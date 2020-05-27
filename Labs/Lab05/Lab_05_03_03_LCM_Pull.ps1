[DscLocalConfigurationManager()]
Configuration LCMPull
{
Param (
    $GUID
)
    Node ms2
    {
        Settings
        {
            ActionAfterReboot    = 'ContinueConfiguration'
            AllowModuleOverWrite = $True
            ConfigurationID      = $GUID
            ConfigurationMode    = 'ApplyAndMonitor'
            RebootNodeIfNeeded   = $True
            RefreshMode          = 'Pull'
        }
        ConfigurationRepositoryWeb PullServer
        {
            ServerURL = "https://pull.contoso.com:8080/PSDSCPullServer.svc"
        }
    }
}



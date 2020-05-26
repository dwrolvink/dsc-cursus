@{
    AllNodes = @(
        @{
            NodeName = 'ms2'
            Feature = 'Web-Mgmt-Console','Web-Scripting-Tools','RSAT-AD-Tools','RSAT-DNS-Server'
        },
        @{
            NodeName = 'ms3'
            Feature = 'Web-Mgmt-Console','Web-Scripting-Tools'
        },
        @{
            NodeName = 'ms4'
            Feature = 'RSAT-AD-Tools','RSAT-DNS-Server'
        }
    )
}

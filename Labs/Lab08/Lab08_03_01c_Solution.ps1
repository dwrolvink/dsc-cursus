Configuration JumpServer_6
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration, contosoComposites

    Node $AllNodes.NodeName
    {
        ForEach ($WindowsFeature in $Node.Feature) {
            WindowsFeature $WindowsFeature
            {
                Name = $WindowsFeature
                IncludeAllSubFeature = $true
                Ensure = 'Present'
            }
        }

        compositeEnableRDP RDP
        {
        }

    }
}

$ServerData = @{
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

cd C:\PShell\Labs\Lab08

JumpServer_6 -ConfigurationData $ServerData

Get-ChildItem .\JumpServer_6\*.mof | ForEach-Object {psEdit $_.FullName}

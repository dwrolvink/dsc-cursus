﻿Configuration JumpServer_6
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
            NodeName = "ms2"
            Feature = 'Web-Mgmt-Console','Web-Scripting-Tools','RSAT-AD-Tools','RSAT-DNS-Server'
         }
    )
}
# Save ConfigurationData in a file with .psd1 file extension

cd C:\PShell\Labs\Lab08

JumpServer_6 -ConfigurationData $ServerData

psEdit .\JumpServer_6\ms2.mof

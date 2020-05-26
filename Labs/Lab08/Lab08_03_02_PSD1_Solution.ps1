Configuration JumpServer_7
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

cd C:\PShell\Labs\Lab08

JumpServer_7 -ConfigurationData .\Lab08_03_02_JumpServer_Solution.psd1

Get-ChildItem .\JumpServer_7\*.mof | ForEach-Object {psEdit $_.FullName}

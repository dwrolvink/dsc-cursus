Configuration JumpServer_6
{
Param(
    [string[]]$ComputerName = $Env:COMPUTERNAME,
    [string[]]$Feature
)
    Import-DscResource -ModuleName PSDesiredStateConfiguration, contosoComposites

    Node $ComputerName
    {
        ForEach ($WindowsFeature in $Feature) {
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

JumpServer_6 -ComputerName ms2 -Feature 'Web-Mgmt-Console','Web-Scripting-Tools','RSAT-AD-Tools','RSAT-DNS-Server'

psEdit .\JumpServer_6\ms2.mof

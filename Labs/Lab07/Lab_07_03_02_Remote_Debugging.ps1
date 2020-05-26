break

Set-Location C:\PShell\Labs\Lab07


Get-DscResource -Module PsDesiredStateConfiguration  | Sort-Object ImplementedAs


Configuration RemoteDebugSample
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node ms1
    {
        Environment EnvVar
        {
            Name   = 'PS_DSC_Workshop'
            Value  = 'A113'
            Ensure = 'Present'
        }

        Service Bits
        {
            Name        = 'Bits'
            StartupType = 'Automatic'
            State       = 'Running'
        }
    }
}

RemoteDebugSample

Start-DscConfiguration -Path .\RemoteDebugSample -Wait -Verbose

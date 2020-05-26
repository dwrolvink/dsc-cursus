<#
Configure MS1 for pull
Publish a config that will generate an error
Update-DscConfiguration without verbose
#>

$ErrorActionPreference = 'SilentlyContinue'

Set-Location C:\PShell\Labs\Lab07

Invoke-Command -ComputerName ms1 -ScriptBlock {
    Remove-Item C:\Windows\System32\Configuration\meta*.mof
}

Configuration CanYouFindThisError
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node ms1
    {
        File DSCTempFolder {
            DestinationPath = 'C:\DSCTemp\'
            Ensure          = 'Present' 
            Type            = 'Directory'
        }

        Archive ExtractZIP {
            Ensure          = 'Present'
            Path            = 'C:\BadPath\LogParser.zip'
            Destination     = 'C:\DSCTemp\logparser\'
            Force           = $true
            DependsOn       = '[File]DSCTempFolder'
        }

        Package InstallLogParser {
            Ensure          = 'Present'
            Name            = 'Log Parser 2.2'
            Path            = 'C:\DSCTemp\logparser\logparser.msi'
            ProductId       = '4AC23178-EEBC-4BAF-8CC0-AB15C8897AC9'
            DependsOn       = '[Archive]ExtractZIP'
        }
    }
}

CanYouFindThisError | Out-Null

$guid = (New-Guid).Guid
$source = ".\CanYouFindThisError\ms1.mof"
$dest   = "C:\Program Files\WindowsPowerShell\DSCService\Configuration\$guid.mof"
Copy-Item -Path $source -Destination $dest
New-DSCChecksum $dest -Force

[DscLocalConfigurationManager()]
Configuration LCMPull
{
Param (
    $GUID
)
    Node ms1
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

LCMPull -GUID $guid | Out-Null

Set-DscLocalConfigurationManager -Path .\LCMPull

Update-DscConfiguration -CimSession ms1 -Wait

$ErrorActionPreference = 'Continue'

Write-Host -ForegroundColor Green -BackgroundColor Black -Object "*** PROCEED WITH THE NEXT LAB STEP ***"

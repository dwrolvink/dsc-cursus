$CompositeCode = @'
Configuration compositeEnableRDP
{
    Import-DscResource -ModuleName xRemoteDesktopAdmin, xNetworking

    xRemoteDesktopAdmin RemoteDesktopSettings
    {
        Ensure = 'Present'
        UserAuthentication = 'Secure'
    }

    xFirewall AllowRDP
    {
        Name = 'DSC - Remote Desktop Admin Connections'
        Group = "Remote Desktop"
        Ensure = 'Present'
        Enabled = $true
        Action = 'Allow'
        Profile = 'Domain'
    }
}
'@

cd \
del "C:\Program Files\WindowsPowerShell\Modules\contosoComposites" -Recurse -Force
New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\contosoComposites\DSCResources\compositeEnableRDP" -ItemType File -Name "compositeEnableRDP.schema.psm1" -Force -Value $CompositeCode | Out-Null
New-ModuleManifest -Path "C:\Program Files\WindowsPowerShell\Modules\contosoComposites\DSCResources\compositeEnableRDP\compositeEnableRDP.psd1" -RootModule "C:\Program Files\WindowsPowerShell\Modules\contosoComposites\DSCResources\compositeEnableRDP\compositeEnableRDP.schema.psm1"
New-ModuleManifest -Path "C:\Program Files\WindowsPowerShell\Modules\contosoComposites\contosoComposites.psd1" -ModuleVersion '1.0'
tree "C:\Program Files\WindowsPowerShell\Modules\contosoComposites" /f /a

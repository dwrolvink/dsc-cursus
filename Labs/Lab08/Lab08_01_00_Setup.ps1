# Fresh install of xNetworking and xRemoteDesktopAdmin

Remove-Item 'C:\Program Files\WindowsPowerShell\Modules\xNetworking' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'C:\Program Files\WindowsPowerShell\Modules\xRemoteDesktopAdmin' -Recurse -Force -ErrorAction SilentlyContinue

# Hard-coded module versions to preserve the labs steps against future module updates
Install-Module -Name xNetworking -RequiredVersion '2.5.0.0' -Force -Verbose
Install-Module -Name xRemoteDesktopAdmin -RequiredVersion '1.1.0.0' -Force -Verbose

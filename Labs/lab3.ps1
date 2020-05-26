[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -PublishLocation https://www.powershellgallery.com/api/v2/package/ -ScriptSourceLocation https://www.powershellgallery.com/api/v2/items/psscript/ -ScriptPublishLocation https://www.powershellgallery.com/api/v2/package/ -InstallationPolicy Trusted -PackageManagementProvider NuGet

Install-Module -name xPSDesiredStateConfiguration -Force

Get-DscResource -Module xPSDesiredStateConfiguration

Get-DscResource -Name xDscWebService -Syntax

..\pullserverHTTPConfig.ps1

PullServerHTTP

Start-DscConfiguration -Path .\PullServerHTTP -Verbose -Wait

& $ENV:Windir\System32\Inetsrv\InetMgr.exe

psEdit C:\PShell\Labs\Lab03\Lab_03_02_01_Install_BaseConfig.ps1 

$ms1 = (New-Guid).Guid
$ms1

Set-Content -Path C:\PShell\Labs\Lab03\MS1guid.txt -Value $ms1 -PassThru 

# Copy mof file to dsc server folder
$destination = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\$ms1.mof"
Copy-Item -Path .\BaseConfig\ms1.mof -Destination $destination -PassThru

# Create checksum for the mof file
New-DscChecksum -Path $destination -Force -Verbose

# Open ms1 local config file
psedit C:\PShell\Labs\Lab03\Lab_03_03_01_Configure_LCM_Pull_Solution.ps1
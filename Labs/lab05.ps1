cd C:\PShell\Labs\Lab05

# Find and review resource code
# =============================
Get-DscResource
Get-DscResource -Module PSDesiredStateConfiguration

Get-Module -Name PSDesiredStateConfiguration | fl *
dir (Get-Module -Name PSDesiredStateConfiguration).ModuleBase
dir (Join-Path (Get-Module -Name PSDesiredStateConfiguration).ModuleBase 'DSCResources')

Get-DscResource Registry | fl *
dir (Get-DscResource Registry).ParentPath
psedit (Get-DscResource Registry).Path

Find-DscResource | select -First 1 | fl *

# Install module/resource
# =======================
# First save to review code for safety
Save-Module -name xnetworking -Path .\
dir .\xNetworking -Recurse


Install-Module xNetworking -Force
Install-Module xSmbShare -Force

Get-DscResource

# Use resources example
# =====================
.\Lab_05_01_03_Configuration_Solution.ps1
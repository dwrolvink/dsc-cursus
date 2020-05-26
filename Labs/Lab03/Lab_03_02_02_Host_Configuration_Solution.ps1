break

# GUID
$ms1 = (New-Guid).Guid
$ms1
Set-Content -Path C:\PShell\Labs\Lab03\MS1guid.txt -Value $ms1 -PassThru

# copy
$destination = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\$ms1.mof"

Copy-Item -Path .\BaseConfig\ms1.mof -Destination $destination -PassThru

New-DscChecksum -Path $destination -Verbose -Force

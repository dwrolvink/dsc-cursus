
cd C:\PShell\Labs\Lab04

dir .\EncryptedPull

$guid = (New-Guid).Guid
$ConfigPath = "C:\Program Files\WindowsPowerShell\DscService\Configuration\$guid.mof"
Copy-Item -Path .\EncryptedPull\ms1.mof -Destination $ConfigPath
New-DscChecksum -Path $ConfigPath -Force

dir "C:\Program Files\WindowsPowerShell\DscService\Configuration\"

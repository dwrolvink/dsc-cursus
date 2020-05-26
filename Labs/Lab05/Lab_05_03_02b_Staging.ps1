cd C:\PShell\Labs\Lab05

# Configuration ID
$guid = (New-Guid).Guid

# MOF
$source = ".\FileServer\ms2.mof"

# Rename and new path
$dest   = "C:\Program Files\WindowsPowerShell\DSCService\Configuration\$guid.mof"

# Copy and checksum
Copy-Item -Path $source -Destination $dest
New-DSCChecksum $dest -Force

# Validate files
Get-ChildItem "C:\Program Files\WindowsPowerShell\DSCService\Configuration\"

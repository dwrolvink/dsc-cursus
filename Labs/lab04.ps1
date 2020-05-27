Set-Location -Path C:\PShell\Labs\Lab04

Get-Service -ComputerName dc -Name certsvc

# Create configuration with clear text password 
# ---------------------------------------------

# List all DSc Resources
Get-DscResource | ForEach-Object { $_.Name ; $_.Properties | Format-Table }

# Open lab file
psedit .\Lab_04_02_01a_Unencrypted_Credentials.ps1  # error example
psedit .\Lab_04_02_01b_Unencrypted_Credentials.ps1  # create cleartext password mof

# Check syntax
Get-Command ClearTextPassword -Syntax

# See plaintext in mof
psedit .\ClearTextPassword\localhost.mof


# Check if certificate is present on a remote machine
#----------------------------------------------------

# Go look at ms1 if the DSC certificate is there
$node = New-PSSession -ComputerName ms1
Enter-PSSession -Session $node

cd cert:
cd .\LocalMachine\My
dir -DocumentEncryptionCert

    # If the document encryption cert does not show up try the following
    gpupdate /force
    Get-Service -ComputerName dc -Name Certsvc | Restart-Service -PassThru -Verbose
    #

# Check cert validity
$cert = dir -DocumentEncryptionCert
$cert | fl *
$cert.PrivateKey
$cert.Verify()

# Import public key of node document encryption certificate to the PULL server
#-----------------------------------------------------------------------------

# Create folder, and export certificate (public key) to there (so we can import it on the PULL server)
cd C:\
md PublicKeys

# Export the certificate public key and view its thumbprint
Export-Certificate -Cert $cert -FilePath C:\PublicKeys\MS1.cer
Get-PfxCertificate -FilePath C:\PublicKeys\MS1.cer

Exit-PSSession

# Import public key on pull server
md C:\PublicKeys
Copy-Item -FromSession $node -Path C:\PublicKeys\MS1.cer -Dest C:\PublicKeys
dir C:\PublicKeys

Remove-PSSession $node

# Use document encryption to secure plaintext password
# ----------------------------------------------------
psedit .\Lab_04_02_03a_Encrypted_Credentials.ps1  # Create encrypted password mof

Get-PfxCertificate -FilePath C:\PublicKeys\MS1.cer

# View encrypted password in mof
psedit .\EncryptedPassword\ms1.mof

# Push LCM config from mof to MS1
Set-DscLocalConfigurationManager -Path .\EncryptedPassword -ComputerName ms1 -Verbose

# Push DSC to MS1
Start-DscConfiguration -Path .\EncryptedPassword -Wait -Verbose -Force

# Check success
Get-DscConfiguration -CimSession ms1
Invoke-Command -ComputerName ms1 -ScriptBlock {net user}



# Build a secure pull server
# ==========================

# Remove previous lab config
Install-WindowsFeature Web-Scripting-Tools
Get-WebSite -Name PSDSC* | Remove-Website

# Request certificate
psedit .\Lab_04_03_01a_CertRequest.ps1

# Configure pull server
psedit .\Lab_04_03_01b_Configure_HTTPS_Pull_Server.ps1

# Test pullserver site
Start-Process "https://pull.contoso.com:8080/PSDSCPullServer.svc"


# Configure nodes to pull
# ==========================
# Create mof file
# ---------------
psedit .\Lab_04_03_02a_Configuration_For_Pull.ps1  # change the cert thumbprint to the value below and run

# Get ms1 cert thumbprint
Get-PfxCertificate -FilePath C:\PublicKeys\MS1.cer

# Place mof file in pull server directory
# ---------------------------------------
# Get guid
$guid =(New-Guid).Guid

# Set mof location/name + copy
$ConfigPath = "C:\Program Files\WindowsPowerShell\DscService\Configuration\$guid.mof"
Copy-Item -Path .\EncryptedPull\ms1.mof -Destination $ConfigPath -Verbose

# Make checksum
New-DscChecksum -Path $ConfigPath -Force

# test
dir "C:\Program Files\WindowsPowerShell\DscService\Configuration\"

# Create pull settings for the node(s)
psedit .\Lab_04_03_03a_LCM_For_Pull.ps1  # change thumbprint, configurationid, and serverurl, then run

# Apply
Set-DscLocalConfigurationManager -Path .\HTTPS_Pull -Verbose

# Force reload
Update-DscConfiguration -Wait -Verbose -ComputerName ms1

# Check mof on the node
Enter-PSSession -ComputerName ms1

Get-Content C:\Windows\System32\Configuration\Current.mof

net localgroup AppServiceGroup

Get-DscConfiguration

Exit-PSSession
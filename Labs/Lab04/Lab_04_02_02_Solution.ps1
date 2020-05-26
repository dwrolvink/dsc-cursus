break

$node = New-PSSession -ComputerName ms1
Enter-PSSession -Session $node
cd Cert:\LocalMachine\My
dir
$cert = Get-Item -Path .\  #Use TAB complete here to get the certificate thumbprint
$cert | fl *
$cert.PrivateKey
$cert.Verify()
cd c:\
md PublicKeys
Export-Certificate -Cert $cert -FilePath C:\PublicKeys\MS1.cer
Get-PfxCertificate -FilePath C:\PublicKeys\MS1.cer
Exit-PSSession

md C:\PublicKeys
Copy-Item -FromSession $node -Path C:\PublicKeys\MS1.cer -Destination C:\PublicKeys
dir C:\PublicKeys

Remove-PSSession $node

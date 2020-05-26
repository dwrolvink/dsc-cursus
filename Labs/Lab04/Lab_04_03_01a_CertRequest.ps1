$Req = @{
    Template          = 'WebServer'
    DnsName           = ''
    SubjectName       = 'CN='
    Url               = 'ldap:'
    CertStoreLocation = 'Cert:\LocalMachine\My'
}
$cert = Get-Certificate @Req
$thumbprint = $cert.Certificate.Thumbprint

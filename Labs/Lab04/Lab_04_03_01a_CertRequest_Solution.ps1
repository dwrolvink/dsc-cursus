$Req = @{
    Template          = 'WebServer'
    DnsName           = 'pull.contoso.com'
    SubjectName       = 'CN=pull.contoso.com'
    Url               = 'ldap:'
    CertStoreLocation = 'Cert:\LocalMachine\My'
}
$cert = Get-Certificate @Req
$thumbprint = $cert.Certificate.Thumbprint

$nodes = 'pull','ms1','ms2'
md C:\PublicKeys -ErrorAction SilentlyContinue
del C:\PublicKeys\*.* -Force -ErrorAction SilentlyContinue

ForEach ($node in $nodes) {
    $pss = New-PSSession $node
    $return = Invoke-Command -Session $pss -ScriptBlock {
        md C:\MyPublicKeys -ErrorAction SilentlyContinue | Out-Null
        $cert = Get-ChildItem Cert:\LocalMachine\My -DocumentEncryptionCert | Where-Object {$_.PrivateKey.KeyExchangeAlgorithm -and $_.Verify()} | Select-Object -First 1
        Export-Certificate -Cert $cert -FilePath "C:\MyPublicKeys\$Env:COMPUTERNAME.cer" -Force | Out-Null
        $cert.Thumbprint
    }
    Copy-Item -FromSession $pss -Path "C:\MyPublicKeys\$node.cer" -Destination C:\PublicKeys -Force

    [PSCustomObject]@{
        Node = $node
        Path = "C:\PublicKeys\$node.cer"
        Thumbprint = $return
    } | Export-Csv -Path C:\PublicKeys\index.csv -Append -NoTypeInformation

    Remove-PSSession $pss
}

Import-Csv C:\PublicKeys\index.csv

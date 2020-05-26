$nodes = Import-Csv C:\PublicKeys\index.csv

$ConfigData = @{ AllNodes = @() }

ForEach ($node in $nodes) {
    $ConfigData.AllNodes += @{
        NodeName        = $node.Node
        CertificateFile = $node.Path
        Thumbprint      = $node.Thumbprint
    }
}

$ConfigData.AllNodes | %{"----";$_}

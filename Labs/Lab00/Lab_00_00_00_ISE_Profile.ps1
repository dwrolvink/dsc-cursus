$pro = @'
$psISE.Options.ErrorBackgroundColor = "red"
$psISE.Options.ErrorForegroundColor = "white"
$psISE.Options.Zoom = 150
'@
New-Item -Path $profile -Value $pro -ItemType File -Force

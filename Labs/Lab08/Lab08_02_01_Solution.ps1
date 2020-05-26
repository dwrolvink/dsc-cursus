cd "C:\Program Files\WindowsPowerShell\Modules\"

md contosoComposites
cd .\contosoComposites

New-ModuleManifest -Path .\contosoComposites.psd1 -ModuleVersion '1.0'

md DSCResources
cd .\DSCResources

md compositeEnableRDP
cd .\compositeEnableRDP

New-Item -ItemType File -Name compositeEnableRDP.schema.psm1
New-ModuleManifest -Path .\compositeEnableRDP.psd1 -RootModule compositeEnableRDP.schema.psm1

cd \
tree "C:\Program Files\WindowsPowerShell\Modules\contosoComposites" /f /a

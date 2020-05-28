psedit C:\PShell\Labs\Lab08\Lab08_01_00_Setup.ps1
psedit C:\PShell\Labs\Lab08\Lab08_01_01a_Original_Configuration.ps1

# Create Composite Module
cd 'C:\Program Files\WindowsPowerShell\Modules'
md contosoComposites
cd .\contosoComposites
New-ModuleManifest -Path .\contosoComposites.psd1 -ModuleVersion '1.0'
md DSCResources

# Create RDP composite
cd .\DSCResources
md compositeEnableRDP
cd .\compositeEnableRDP
New-Item -ItemType File -name compositeEnableRDP.schema.psm1
New-ModuleManifest -Path .\compositeEnableRDP.psd1 -RootModule compositeEnableRDP.schema.psm1

# Check
cd \
tree "C:\Program Files\WindowsPowerShell\Modules\contosoComposites" /f /a

# Define RDP composite
psEdit "C:\Program Files\WindowsPowerShell\Modules\contosoComposites\DSCResources\compositeEnableRDP\compositeEnableRDP.schema.psm1"

# Check to see if resource shows up
Get-DscResource

# Use composite in configuration
psedit C:\PShell\Labs\Lab08\Lab08_02_03_Configuration_Solution.ps1

# -----------

psedit C:\PShell\Labs\Lab08\Lab08_03_01a_Parameter_Configuration.ps1

psedit C:\PShell\Labs\Lab08\Lab08_03_01b_Solution.ps1

psedit C:\PShell\Labs\Lab08\Lab08_03_02_PSD1.ps1
$Properties = @(
    New-xDscResourceProperty -Name Path -Type String -Attribute Key
    New-xDscResourceProperty -Name FileAgeDays -Type Uint16  -Attribute Required
    New-xDscResourceProperty -Name OldFiles -Type String[] -Attribute Read
    New-xDscResourceProperty -Name NewFiles -Type String[] -Attribute Read
)

$Params = @{
 Name         = 'Contoso_xClearLogFiles'
 FriendlyName = 'xClearLogFiles' 
 ModuleName   = 'xAppMaintenance'
 Path         = "$env:ProgramFiles\WindowsPowerShell\Modules"
 Property     = $Properties
 }

# Pass in the above parameters to the cmdlet using Splatting @Params
New-xDscResource @Params -Force

psEdit "$env:ProgramFiles\WindowsPowerShell\Modules\xAppMaintenance\DSCResources\Contoso_xClearLogFiles\Contoso_xClearLogFiles.psm1"

psEdit "$env:ProgramFiles\WindowsPowerShell\Modules\xAppMaintenance\DSCResources\Contoso_xClearLogFiles\Contoso_xClearLogFiles.schema.mof"

tree.com "$env:ProgramFiles\WindowsPowerShell\Modules\xAppMaintenance" /F /A

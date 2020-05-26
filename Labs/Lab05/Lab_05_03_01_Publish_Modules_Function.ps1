Function Publish-DscResourcePull {
Param (
    [string[]]
    $Module
)
    $PullModulePath = "$Env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"

    ForEach ($ModuleName in $Module) {
        $m = Get-Module $ModuleName -ListAvailable
        $PullModuleFile = Join-Path -Path $PullModulePath -ChildPath "$($m.Name)_$($m.Version).zip"
        Compress-Archive -Path "$($m.ModuleBase)\*" -DestinationPath $PullModuleFile -Update -Verbose
        New-DSCCheckSum $PullModuleFile -Force
    }
}


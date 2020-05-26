break


#region SETUP #################################################################

cd C:\PShell\Labs\Lab07

# Reset the LCM
Remove-Item C:\Windows\System32\Configuration\meta*.mof

#endregion ####################################################################



#region IDLE ##################################################################

Get-DscLocalConfigurationManager

#endregion ####################################################################



#region BUSY ##################################################################
Configuration LCMStateBusy
{
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node localhost
    {
        Script Wait1
        {
            GetScript  = '@{Result=10}'
            SetScript  = 'Start-Sleep -Seconds 10'
            TestScript = 'Return $false'
        }

        Script Wait2
        {
            GetScript  = '@{Result=10}'
            SetScript  = 'Start-Sleep -Seconds 10'
            TestScript = 'Return $false'
            DependsOn  = '[Script]Wait1'
        }

        Script Wait3
        {
            GetScript  = '@{Result=10}'
            SetScript  = 'Start-Sleep -Seconds 10'
            TestScript = 'Return $false'
            DependsOn  = '[Script]Wait2'
        }
    }
}

LCMStateBusy
Start-DscConfiguration -Path .\LCMStateBusy -Wait -Verbose -Force

#endregion ####################################################################



#region EXISTING ##############################################################

Start-DscConfiguration -UseExisting -Wait -Verbose -Force

#endregion ####################################################################



#region PENDING ###############################################################

Publish-DscConfiguration -Path .\LCMStateBusy

Get-DscLocalConfigurationManager

#endregion ####################################################################



#region STOP ##################################################################

Start-DscConfiguration -UseExisting -Wait -Verbose

#endregion ####################################################################

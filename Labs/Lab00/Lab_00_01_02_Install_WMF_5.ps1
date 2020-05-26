#region PUSH WMF 5 CONFIGURATION ##############################################

# Configuration to install WMF5
Configuration InstallWMF5
{
    Import-DscResource -Module PSDesiredStateConfiguration, xWindowsUpdate, xPendingReboot

    Node ('MS1','MS2','PULL')
    {

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            RefreshMode        = 'PUSH'
        }

        File TempDir
        {
            DestinationPath = 'C:\Temp'
            Force           = $True
            Ensure          = 'Present'
            Type            = 'Directory'
        }

        File WMF5Source
        {
            DestinationPath = 'C:\Temp\Win8.1AndW2K12R2-KB3134758-x64.msu'
            Ensure          = 'Present'
            SourcePath      = '\\PULL\PShell\WMF5\Win8.1AndW2K12R2-KB3134758-x64.msu'
            Type            = 'File'
            Force           = $True
            DependsOn       = '[File]TempDir'
        }

        xHotFix WMF5Install
        {
            Id        = 'KB3134758'
            Ensure    = 'Present'
            Path      = 'C:\Temp\Win8.1AndW2K12R2-KB3134758-x64.msu'
            DependsOn = '[File]WMF5Source'
        }

        # xHotFix should trigger a reboot to DSC, but it doesn't yet.
        xPendingReboot WMF5Reboot
        {
            Name      = 'RebootMe'
            DependsOn = '[xHotFix]WMF5Install'
        }
    }
}

# Working folder
Set-Location C:\PShell\Labs\Lab00

# Generate the MOFs
InstallWMF5
#endregion

#region PUSH the META CONFIGURATION ###########################################
# Configure the LCMs
Set-DscLocalConfigurationManager -Path .\InstallWMF5 -Verbose
#endregion

#region PUSH WMF 5 CONFIGURATION to MS1 and MS2 ###############################
# Apply the configurations to the remote nodes first and reboot
Start-DscConfiguration -Path .\InstallWMF5 -ComputerName MS1,MS2 -Wait -Verbose -Force
#endregion

#region PUSH WMF 5 CONFIGURATION to PULL ######################################
# Apply and reboot this server last
Start-DscConfiguration -Path .\InstallWMF5 -ComputerName PULL -Wait -Verbose -Force

#endregion ####################################################################

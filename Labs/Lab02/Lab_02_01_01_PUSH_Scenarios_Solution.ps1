break

#Region Task 2.1.1

configuration JumpServer
{
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node LocalHost
    {
        WindowsFeature FileServices
        {
           Ensure = "Present"
           Name = "RSAT-File-Services"
        }      
    }
}

Set-Location C:\PShell\Labs\Lab02

Get-WindowsFeature -Name RSAT*

Get-Command -CommandType Configuration

Get-Command -Name Ju*

JumpServer

#endregion


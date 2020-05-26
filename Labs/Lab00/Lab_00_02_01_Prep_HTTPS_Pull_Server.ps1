
#region INSTALL MODULE ########################################################

Install-Module -Name xPsDesiredStateConfiguration -RequiredVersion 5.0.0.0 -Force -Verbose

#endregion ####################################################################


#region REMOVE HTTP PULL ######################################################

# Brute force remove the HTTP web site
Install-WindowsFeature Web-Scripting-Tools
Get-WebSite -Name PSDSC* | Remove-Website

#endregion ####################################################################

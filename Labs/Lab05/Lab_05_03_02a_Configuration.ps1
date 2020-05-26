Configuration FileServer
{

    Import-DscResource -ModuleName xNetworking, xSmbShare, PSDesiredStateConfiguration

    Node ms1
    {
    
        xFirewall SMB-In
        {
            Name         = 'SMB-In'
            DisplayName  = 'SMB-In'
            Group        = 'File and Printer Sharing'
            Direction    = 'Inbound'
            Action       = 'Allow'
            Enabled      = $true
            LocalPort    = 445
            Protocol     = 'TCP'
            Profile      = @('Domain','Private')
            Ensure       = 'Present'
        }


        xFirewall SMB-Out
        {
            Name         = 'SMB-Out'
            DisplayName  = 'SMB-Out'
            Group        = 'File and Printer Sharing'
            Direction    = 'Outbound'
            Action       = 'Allow'
            Enabled      = $true
            RemotePort   = 445
            Protocol     = 'TCP'
            Profile      = @('Domain','Private')
            Ensure       = 'Present'
        }

        File DirectorySource
        {
            Ensure          = 'Present'
            Type            = 'Directory'
            DestinationPath = 'C:\FileShare\'
            SourcePath      = '\\pull\pshell\labs'
            Recurse         = $true
            MatchSource     = $true
            Checksum        = 'ModifiedDate'
            DependsOn       = @('[xFirewall]SMB-In','[xFirewall]SMB-Out')
        }

        xSmbShare CreateShare
        {
            Name       = 'SourceShare'
            Path       = 'C:\FileShare'
            ReadAccess = 'Everyone'
            Ensure     = 'Present'
            DependsOn  = '[File]DirectorySource'
        }

    }

}

FileServer

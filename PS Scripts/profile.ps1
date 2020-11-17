function New-CNTrustedHost {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string] $Computer,
        [Parameter(Position=1, Mandatory=$false)]
        [switch] $Silently
    )
    <#
        .SYNOPSIS
            This function adds a computer to the WSMan trsuted hosts.
        .DESCRIPTION
            This function edis the value in WSMan:\localhost\Client\TrustedHosts
        .PARAMETER Computer
            This is a string that specifies the name of the computer.
        .PARAMETER Silently
            This specifies that the function should output to the console.
        .INPUTS
            string, switch
        .EXAMPLE
            New-CNTrustedHost -Computers PC -Silently
        .NOTES
            Author: Nicolás Castellán
    #>
    #This function was made by Nicolás Castellán to add a PC to the trusted hosts.
    Write-Verbose -Message "Function has started."
    # This part of the function checks for admin permissions.
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
        Write-Host "This function needs admin privileges..." -ForegroundColor DarkRed
    } else {Write-Verbose -Message "Admin privileges found."}
    # Now the function adds the computer to the trusted hosts.
    Write-Verbose -Message "Adding $Computer to the trusted hosts..."
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $Computer -Force # This line adds the computer
    if (!$Silently) {Write-Host "$Computer has been added as a trusted host." -ForegroundColor Green}
}

function Clear-CNTrustedHost {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false)]
        [switch] $Silently
    )
    <#
        .SYNOPSIS
            This function clears the WSMan trsuted hosts.
        .DESCRIPTION
            This function clears the values in WSMan:\localhost\Client\TrustedHosts
        .PARAMETER Silently
            This specifies that the function should output to the console.
        .INPUTS
            switch
        .EXAMPLE
            Clear-CNTrustedHost -Silently
        .NOTES
            Author: Nicolás Castellán
    #>
    #This function was made by Nicolás Castellán to add a PC to the trusted hosts.
    Write-Verbose -Message "Function has started."
    # This part of the function checks for admin permissions.
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
        Write-Host "This function needs admin privileges..." -ForegroundColor DarkRed
    } else {
        Write-Verbose -Message "Admin privileges found."
        # Now the function clears the registry.
        Write-Verbose -Message "Clearing..."
        Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
        if (!$Silently) {Write-Host "The trusted hosts have been cleared." -ForegroundColor Green}
    }
}

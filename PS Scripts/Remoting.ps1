<#
    .SYNOPSIS
        This script adds or removes computers from the WSMan trsuted hosts.
    .DESCRIPTION
        This script edis the values in WSMan:\localhost\Client\TrustedHosts
    .PARAMETER Computer
        This is a string that specifies the name of the computer.
    .PARAMETER Add
        This specifies to add the computer to the trusted hosts.
    .PARAMETER Remove
        This specifies to remove the computer from the trusted hosts.
    .PARAMETER Clear
        This removes all trusted hosts.
    .PARAMETER Silently
        This specifies taht the script should output to the console.
    .INPUTS
        string[], switch/switch/switch, switch
    .EXAMPLE
        .\Remoting.ps1 -Computers PC -Add
    .EXAMPLE
        .\Remoting.ps1 -Computes PC -Remove -Silently
    .EXAMPLE
        .\Remoting.ps1 -Computers PC -Clear
    .NOTES
        Author: @Nicolas1188
#>
#This script was made by @Nicolas1188 to add/remove a PC from the trusted hosts.

# Apache License, version 2

# Copyright 2020 Nicolas1188

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[CmdletBinding(DefaultParameterSetName='Add')]
param (
    [Parameter(ParameterSetName='Clear', Position=0, Mandatory=$false)]
    [switch] $Clear,
    [Parameter(ParameterSetName='Add', Position=0, Mandatory=$true)]
    [Parameter(ParameterSetName='Remove', Position=0, Mandatory=$true)]
    [string] $Computer,
    [Parameter(ParameterSetName='Add', Position=1, Mandatory=$false)]
    [switch] $Add,
    [Parameter(ParameterSetName='Remove', Position=1, Mandatory=$false)]
    [switch] $Remove,
    [Parameter(ParameterSetName='Add', Position=2, Mandatory=$false)]
    [Parameter(ParameterSetName='Remove', Position=2, Mandatory=$false)]
    [Parameter(ParameterSetName='Clear', Position=1, Mandatory=$false)]
    [switch] $Silently
)

Write-Verbose -Message "Script has started."
# This part of the script checks and asks for admin permissions.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "This script needs admin privileges..." -ForegroundColor DarkRed
    Start-Sleep 1
    Exit
} else {Write-Verbose -Message "Admin privileges found."}

#region 1 Adding to trusted hosts.
if ($Add) {
    Write-Verbose -Message "Adding $Computer to the trusted hosts..."
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $Computer -Force # This line adds the computer
    Write-Verbose -Message "$Computer"
    if (!$Silently) {Write-Host "$Computer has been added as a trusted host." -ForegroundColor Green}
}
#endregion

#region 2 Removing the computer from the trusted hosts.
if ($Remove) {
    Write-Verbose -Message "Processing: $Computer..."
    # The following line takes the name of the computer and configures it to be replaced.
    $ComputerToRemove = ((Get-ChildItem WSMan:\localhost\Client\TrustedHosts).Value).Replace($Computer,"") # This line removes the computer
    Set-Item WSMan:\localhost\Client\TrustedHosts $ComputerToRemove -Force
    Write-Verbose -Message "$Computer has been removed."
    if (!$Silently) {Write-Host "$Computer has been removed from the trusted hosts." -ForegroundColor Green}
}
#endregion

#region 3 Clearing the trusted hosts.
if ($Clear) {
    Write-Verbose -Message "Clearing..."
    Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
    if (!$Silently) {Write-Host "The trusted hosts have been cleared." -ForegroundColor Green}
}
#endregion

<#
    .SYNOPSIS
        This script installs Office.
    .DESCRIPTION
        This script will download and install Office using config files and MS Guides KMS servers.
    .PARAMETER Office2019
        Switch to install Office 365 and activate it as Office 2019.
    .PARAMETER Office2019Enterprise
        Switch to install Office 2019 Enterprise and activate it as Office 2019.
    .EXAMPLE
        'activate.ps1' -Office2019
#>

# MIT License

# Copyright (c) 2020 Nicolas1188

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

[CmdletBinding()]
param (

    # Install Office 365.
    [Parameter(ParameterSetName='2019',Mandatory=$true,Position=0)]
    [switch] $Office2019,

    # Install Office 2019.
    [Parameter(ParameterSetName='2019E',Mandatory=$true,Position=0)]
    [switch] $Office2019Enterprise,

)

# This part of the script checks and asks for admin permissions.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {

    Write-Host 'This script needs admin privileges...' -ForegroundColor DarkRed
    Start-Sleep 2
    exit

} else {Write-Verbose -Message 'Admin privileges found.'}


# Now the installation begins.
Push-Location

# Choose the config file.
if ($Office2019) {$Choice = config2019.xml}
if ($Office2019Enterprise) {$Choice = config2019E.xml}
Write-Host "Installing Office using: $Choice..."

Set-Location $PSScriptRoot

# Get start time, install, and get endtime.
$StartTime = Get-Date
& .\setup.exe /configure .\configs\$Choice
$EndTime = Get-Date

# Format time elapsed so it's pretty.
$TimeElapsed = ("{0}:{1}:{2}" -f `
("{0:d2}" -f ($EndTime - $StartTime).Hours), `
("{0:d2}" -f ($EndTime - $StartTime).Minutes), `
("{0:d2}" -f ($EndTime - $StartTime).Seconds))

Write-Host "Time taken to install: $TimeElapsed"

Pop-Location
<#
    .SYNOPSIS
        This script installs Office using the office deployment tool.
    .DESCRIPTION
        This script will download and install Office using config files and MS Guides KMS servers.
    .PARAMETER Office2019
        Switch to install Office 365 and activate it as Office 2019.
    .PARAMETER Office2019Enterprise
        Switch to install Office 2019 Enterprise and activate it as Office 2019.
    .EXAMPLE
        'activate.ps1' -Office2019
#>

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

# This file was made by Nicolas1188,
# This is the repository: https://github.com/Nicolas1188/My-PC-Share.git

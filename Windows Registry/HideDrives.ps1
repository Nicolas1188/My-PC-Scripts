<#
    .SYNOPSIS
        This script hides/unhides drive letters from the file explorer.
    .DESCRIPTION
        This script edits a registry key located in:
        HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
        "NoDrives":dword=XXXXXXXX
    .PARAMETER Letters
        A character or array of characters to specify the drive letter to hide.
    .PARAMETER Unhide
        A swith to make the script delete the registry key.
    .PARAMETER HideAll
        A switch to hide all drives.
    .PARAMETER Silently
        A switch to make the script run without output to the console.
    .INPUTS
        String/switch/switch, switch
    .EXAMPLE
        .\HideDrives.ps1 -Letters A -Silently
    .EXAMPLE
        .\HideDrives.ps1 -Letters C, D
    .EXAMPLE
        .\HideDrives.ps1 -Unhide
    .EXAMPLE
        .\HideDrives.ps1 -HideAll
    .NOTES
        Author: @Nicolas1188
#>
# This script was written by @Nicolas1188 to hide / unhide drive letters from the file explorer using a Windows registry edit.

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

#region Initialization
#===========================================================================

[CmdletBinding(DefaultParameterSetName='Letters')]
param (

    # The first 3 switches are mutually exclusive.

    # The letters are specified in this parameter.
    [Parameter(ParameterSetName='Letters', Position=0, Mandatory=$true)]
    [char[]] $Letters,

    # This is is the switch to hide all.
    [Parameter(ParameterSetName='HideAll', Position=0,Mandatory=$true)]
    [switch] $HideAll,

    # This is the switch to unhide.
    [Parameter(ParameterSetName='Unhide', Position=0, Mandatory=$true)]
    [switch] $Unhide,

    # Switch to run silently, it belongs to the three previous sets.
    [Parameter(ParameterSetName='Letters', Position=1, Mandatory=$false)]
    [Parameter(ParameterSetName='HideAll', Position=1, Mandatory=$false)]
    [Parameter(ParameterSetName='Unhide', Position=1, Mandatory=$false)]
    [switch] $Silently

)

# This part of the script checks for admin permissions.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {

    if (!$Silently) {Write-Host "This script needs admin privileges." -ForegroundColor DarkRed}
    exit

} else {Write-Verbose -Message "Admin privileges found."}

# This function prompts the user to log off and exits the script, it will not run if the "Silently" switch is used.
function Start-Logoff {

    if (!$Silently) {

        if ((Read-Host -Prompt "Do you want to log off now for the changes to take effect? (Y/N)") -eq "Y") {

            Write-Host "Logoff in 10 seconds..." -ForegroundColor Blue
            Start-Sleep 10
            shutdown /l

        }

        exit

    }

}

$RegKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Write-Verbose -Message "Registry Key: $RegKey"

#===========================================================================
#endregion Initialization


#region Checking switches
#===========================================================================

if ($Unhide) {

    # Removes the registry key.
    Remove-ItemProperty -Path $RegKey -Name NoDrives -ErrorAction Ignore

    if (!$Silently) {Write-Output "" "The registry key has been removed." ""}

    Start-Logoff

}

if ($HideAll) {

    # Assigns the key a value to hide all drives.
    Set-ItemProperty -Path $RegKey -Name NoDrives -Value 67108863 -Type "DWord"

    if (!$Silently) {Write-Output "" "The Registry key has been set to hide all drives." ""}

    Start-Logoff

}

#===========================================================================
#endregion Checking switches


#region Editing the registry
#===========================================================================

# This is the value that'll be used to edit the registry.
$Subtotal = 0

# This foreach loop assigns the decimal value resulting from the following multiple ifs statement to the $Subtotal value.
foreach ($Letter in $Letters) {

    # Writing verbose output to separate the processing of each letter.
    if ($Letters.Count -gt 1) {Write-Verbose -Message "-----------------------------------"}
    Write-Verbose -Message "Finding value for letter $Letter."

    # Assigning a value to each letter.
    if ($Letter -eq "A") {$dec = 1
    } elseif ($Letter -eq "B") {$dec = 2
    } elseif ($Letter -eq "C") {$dec = 4
    } elseif ($Letter -eq "D") {$dec = 8
    } elseif ($Letter -eq "E") {$dec = 16
    } elseif ($Letter -eq "F") {$dec = 32
    } elseif ($Letter -eq "G") {$dec = 64
    } elseif ($Letter -eq "H") {$dec = 128
    } elseif ($Letter -eq "I") {$dec = 256
    } elseif ($Letter -eq "J") {$dec = 512
    } elseif ($Letter -eq "K") {$dec = 1024
    } elseif ($Letter -eq "L") {$dec = 2048
    } elseif ($Letter -eq "M") {$dec = 4096
    } elseif ($Letter -eq "N") {$dec = 8192
    } elseif ($Letter -eq "O") {$dec = 16384
    } elseif ($Letter -eq "P") {$dec = 32768
    } elseif ($Letter -eq "Q") {$dec = 65536
    } elseif ($Letter -eq "R") {$dec = 131072
    } elseif ($Letter -eq "S") {$dec = 262144
    } elseif ($Letter -eq "T") {$dec = 524288
    } elseif ($Letter -eq "U") {$dec = 1048576
    } elseif ($Letter -eq "V") {$dec = 2097152
    } elseif ($Letter -eq "W") {$dec = 4194304
    } elseif ($Letter -eq "X") {$dec = 8388608
    } elseif ($Letter -eq "Y") {$dec = 16777216
    } elseif ($Letter -eq "Z") {$dec = 33554432
    }

    # More verbose output.
    Write-Verbose -Message "The value of letter $Letter is $dec."
    $Subtotal += $dec
    Write-Verbose -Message "The Subtotal now is $Subtotal."

}

if ($Letters.Count -gt 1) {Write-Verbose -Message "-----------------------------------"}

# Editing the registry key with the $Subtotal value.
Set-ItemProperty -Path $RegKey -Name NoDrives -Value $Subtotal -Type "DWord"

# Now the script talks to the user.
$HexNumber = '{0:x8}' -f $Subtotal

if (!$Silently) {

    Write-Output "" "The key has been set with the following value:" "Decimal= $Subtotal" "Hexadecimal= $HexNumber" ""

}

Start-Logoff

#===========================================================================
#endregion Editing the registry

# This file was made by Nicolas1188,
# This is the repository: https://github.com/Nicolas1188/My-PC-Share.git

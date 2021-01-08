<#
    .SYNOPSIS
        This script backs up most of Nico's files
    .DESCRIPTION
        This script will create a folder to BackUp:
        1. Documents
        2. Pictures
        3. Music
        4. Videos
        5. Minecraft (AppData\.minecraft)
        6. Notepad++ settings
        7. Windows Terminal settings
    .PARAMETER Path
        This is a mandatory parameter to specify the path where to create the BackUp
    .PARAMETER Log
        This is a parameter to create a log of the BackUp process.
        It's useful if, in case of data loss, try to track the issue from this script.
    .PARAMETER SkipWarning
        This is a switch to skip the warning at the beginning of the script.
    .PARAMETER SaveSettings
        This is a switch to save the settings of Windows Terminal and Notepad++ before backing up.
    .PARAMETER Minecraft
        This is a switch to specify to also save Minecraft.
    .PARAMETER Extras
        This is an array of strings to write the path to extra folders to back up.
    .EXAMPLE
        'QuickBackUp.ps1' -Path D:\
    .EXAMPLE
        'QuickBackUp.ps1' -Path D:\ -Log -SaveSettings -Extras 'C:\Example'
    .NOTES
        Author: @nico-castell
#>
# This script was written by @nico-castell to create a quick backup for the user

# MIT License

# Copyright (c) 2021 nico-castell

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

    # Create the BackUp in ___.
    [Parameter(Position=0, Mandatory=$true)]
    [string] $Path,

    # Create a log file of the BackUp process.
    [Parameter(Position=1)]
    [switch] $Log,

    # Skip the cancel timer.
    [Parameter(Position=2)]
    [switch] $SkipWarning,

    # Save settings before backing them up.
    [Parameter(Position=3)]
    [switch] $SaveSettings,

    # Create a BackUp of $env:USERNAME\AppData\Roaming\.minecraft
    [Parameter(Position=4)]
    [switch] $Minecraft,

    # Add extra folders to back up.
    [Parameter(Position=5)]
    [string[]] $Extras

)


#region Warnings!
#===========================================================================

# Preparations for the backup.
$BeginningStartTime = Get-Date # For timing the script.
Push-Location # To avoid bring the user back to the initial directory.
$Date = Get-Date -Format "MMM d, yyyy" # For the transcript.

# If the warning is not skipped, this code will run.
if (!$SkipWarning) {

    # This for loop makes the text blink 5 times.
    for ($Times = 0; $Times -lt 5; $Times++) {

        if ($Times % 2 -eq 0) {

            # Show text in even numbers.
            Write-Host -NoNewline "`rCreating a BackUp of the user: $env:COMPUTERNAME\$env:USERNAME in $Path."

        } else {

            # Hide text in odd numbers.
            Write-Host -NoNewline "`r                                                                        "

        }

        # Wait to blink again.
        Start-Sleep -Milliseconds 200

    }

}

# This ensures the blinking text doesn't end up hidden.
Write-Host -NoNewline "`rCreating a BackUp of the user: $env:COMPUTERNAME\$env:USERNAME in $Path."
Write-Host ""

# This is a warning to cancel because teh script can take a long, long time.
if (!$SkipWarning) {

    Write-Host "Note that this script can take a long (very long) time." -ForegroundColor Red

    # this timer gives the user ~15 seconds to cancel before the rest of the script begins.
    for ($Sec = 15; $Sec -gt -1; $Sec--) {

        $var = ("{0:d2}" -f $Sec)
        Write-Host -NoNewline "`rYou have $var seconds to cancel (^C)" -ForegroundColor Red
        Start-Sleep -Seconds 1

    }

    Write-Host ""

}

# If the log parameter is set, there will be a transcript of the script's output.
if ($Log) {

    # The file is stored in a temporary directory in C:
    # (Note that for this to run in linux, sudo privileges will be required.)
    New-Item -Name 'TemporalFolder' -Path $env:SystemDrive -ItemType Directory -Force | Out-Null
    Start-Transcript -Path "$env:SystemDrive\TemporalFolder\${Date}.log" -Force | Out-Null

}

# Shows the start time of the script.
Write-Host "Script started at $(Get-Date -Format "T")." -ForegroundColor Green

#===========================================================================
#endregion Warnings!


#region Saving settings.
#===========================================================================

if ($SaveSettings) {

    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
    # Accessing the saved settings folder to run the scripts.
    Write-Host "Accessing saved settings folder..."
    Set-Location "$PSScriptRoot\..\Saved settings files" # This is a relative parameter, it can break.

    # The ps1 scripts to save the Windows Terminal & Notepad++ settings are run here.
    Write-Host "Saving Windows Terminal settings..."
    & '.\WinTerminal\SaveCurrentFile.ps1'
    Write-Host "Saving Notepad++ settings..."
    & '.\WinTerminal\SaveCurrentFile.ps1'

    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue

}

#===========================================================================
#endregion Saving settings.


# Setting the Backing directory of the script.
$BkPath = New-Item -Path $Path -Type Directory -Name ${Date} -Force

<#
    What follows now are 3 regions specialized in backing 3 diferent things:
        1. Home directory. (Backed by default)
        2. Minecraft. (-Minecraft parameter)
        3. Extras. (-Extras parameter)

    They can't be nested in one region because regions 2 & 3 aren't always used, so separating them from
    the first region allows them to be controlled by passing parameters to the script.
#>


#region Libraries
#===========================================================================
# In this region the BakUps for Documents, Pictures, Music, & Videos will be created.

Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
Write-Host "Accesing User folder..."
Set-Location -Path $env:USERPROFILE
$Libraries = 'Desktop', 'Documents', 'Music', 'Pictures', 'Videos'
# The folder has been accessed and the array of directories to copy defined.

foreach ($Folder in $Libraries) {

    # Start time of the copying of $Folder.
    $StartTime = Get-Date
    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
    Write-Host "Started copying $Folder at $(Get-Date -Format "T")."

    # Actual copying of the directory.
    Copy-Item -Path $env:USERPROFILE\$Folder -Destination $BkPath -Recurse -Force -ErrorAction SilentlyContinue

    # Stop time of the copying of $Folder, and time span.
    $EndTime = Get-Date
    $TimeElapsed = ("{0}:{1}:{2}" -f ("{0:d2}" -f ($EndTime - $StartTime).Hours), ("{0:d2}" -f ($EndTime - $StartTime).Minutes), ("{0:d2}" -f ($EndTime - $StartTime).Seconds))
    Write-Host "Finished copying $Folder at $(Get-Date -Format "T") ($TimeElapsed)"

}

Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
Write-Host "Cleaning..."
$CleaningList = 'Registry_BackUps', 'PowerShell', 'WindowsPowerShell', 'Zoom', 'My Music', 'My Pictures', 'My Videos'

# The previous $CleaningList and this loop clean some files that change from system to system, or are the result of Windows, well... being Windows.
foreach ($Item in $CleaningList) {

    Remove-Item -Path "$BkPath\Documents\$Item" -Recurse -Force -ErrorAction SilentlyContinue

}

Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue

#===========================================================================
#endregion Libraries


#region Minecraft
#===========================================================================
# If the -Minecraft switch is used, this region will run.

if ($Minecraft) {

    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
    # Creating the destination folder.
    Write-Host "Creating folder for Minecraft BackUp."
    New-Item -Path $BkPath -Name 'Minecraft' -Type Directory | Out-Null

    # The -ErrorAction break is used to avoid running this if the -Minecraft switch has been used, but %AppData%\.minecraft doesn't exist.
    Write-Host "Accesing .minecraft folder..."
    Set-Location $env:APPDATA\.minecraft -ErrorAction Break

    # The libraries and files are defined here and then 2 foreach loops will handle each list.
    $Libraries = 'saves', 'resourcepacks', 'screenshots'
    $Files = 'launcher_profiles.json', 'options.txt', 'optionsof.txt', 'servers.dat', 'servers.dat_old'

    # Copying the directories.
    foreach ($Folder in $Libraries) {

        # Getting the start time of the copy of $Folder.
        $StartTime = Get-Date
        Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
        Write-Host "Started copying $Folder at $(Get-Date -Format "T")."

        # Copying $Folder.
        Copy-Item -Path .\$Folder -Destination $BkPath\Minecraft -Recurse -Force -ErrorAction SilentlyContinue

        # Getting the end time and the time span.
        $EndTime = Get-Date
        $TimeElapsed = ("{0}:{1}:{2}" -f ("{0:d2}" -f ($EndTime - $StartTime).Hours), ("{0:d2}" -f ($EndTime - $StartTime).Minutes), ("{0:d2}" -f ($EndTime - $StartTime).Seconds))
        Write-Host "Finished copying $Folder at $(Get-Date -Format "T") ($TimeElapsed)."

    }

    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
    # Start time of the copy of the minecraft files.
    $StartTime = Get-Date
    Write-Host "Started copying Minecraft's files at $(Get-Date -Format "T")."

    # The loop that copies each file.
    foreach ($File in $Files) {

        # SilentlyContinue is used because sometimes a file has not been created because the game hasn't been configured, eg. optionsof.txt.
        Copy-Item -Path .\$File -Destination $BkPath\Minecraft -Force -ErrorAction SilentlyContinue

    }

    # Getting the end time of the copying of the minecraft files, and time span.
    $EndTime = Get-Date
    $TimeElapsed = ("{0}:{1}:{2}" -f ("{0:d2}" -f ($EndTime - $StartTime).Hours), ("{0:d2}" -f ($EndTime - $StartTime).Minutes), ("{0:d2}" -f ($EndTime - $StartTime).Seconds))
    Write-Host "Finished copying Minecraft's files at $(Get-Date -Format "T") ($TimeElapsed)."
    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue

}

#===========================================================================
#endregion Minecraft


#region Extras
#===========================================================================

# Copying extra folders defined by the -Extras parameter.
# This will only run if there is at least something in -Extras.
if ($Extras.Count -gt 0) {

    # Beginning the loop through each file or directory to copy.
    foreach ($Item in $Extras) {

        Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue
        Write-Host "Creating folder to copy contents..."
        # This will delete everything prior to the last \ to use the name of the file/directory to make the backup.
        $To = $Item.Substring($Item.LastIndexOf("\") + 1)
        $WhereTo = New-Item -Path $BkPath -Type Directory -Name $To

        # Accessing the location and listing it's contents.
        Write-Host "Accessing $Item..."
        Set-Location $Item
        $List = Get-ChildItem

        # Timing the copy of the file/directory.
        $StartTime = Get-Date
        Write-Host "Started copying $Item at $(Get-Date -Format "T")."

        # Actually copying the files/directories.
        foreach ($Object in $List) {

            Copy-Item -Path $Object -Destination $WhereTo -Recurse -Force

        }

        # Getting the end time, and time span.
        $EndTime = Get-Date
        $TimeElapsed = ("{0}:{1}:{2}" -f ("{0:d2}" -f ($EndTime - $StartTime).Hours), ("{0:d2}" -f ($EndTime - $StartTime).Minutes), ("{0:d2}" -f ($EndTime - $StartTime).Seconds))
        Write-Host "Finished copying $Item at $(Get-Date -Format "T") ($TimeElapsed)."

    }

    Write-Host "---------------------------------------------------------------------------" -ForegroundColor Blue

}

#===========================================================================
#endregion Extras

# Returning to the original directory.
Pop-Location

# Getting the end time of the script, and the total time span of it.
$EndingEndTime = Get-Date

# Formatting the total time elapsed into a readable string.
$TotalTimeElapsed = ("{0}:{1}:{2}" -f `
("{0:d2}" -f ($EndingEndTime - $BeginningStartTime).Hours), `
("{0:d2}" -f ($EndingEndTime - $BeginningStartTime).Minutes), `
("{0:d2}" -f ($EndingEndTime - $BeginningStartTime).Seconds))

Write-Host "Script has ended in $TotalTimeELapsed." -ForegroundColor Green

# Stopping the transcript and saving it with the rest of the backup, then removing the temporary directory.
Stop-Transcript | Out-Null
Move-Item -Path "$env:SystemDrive\TemporalFolder\${Date}.log" -Destination $Path -Force
Remove-Item -Path "$env:SystemDrive\TemporalFolder" -Force | Out-Null

# Thanks for downloading, and enjoy!

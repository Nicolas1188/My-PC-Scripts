# This part of the script checks and asks for admin permissions.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "This script needs admin privileges..." -ForegroundColor DarkRed
    Start-Process powershell.exe -ArgumentList ("-ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Start-Sleep 1
    Exit
} else {Write-Verbose -Message "Admin privileges found."}

# This part of the script checks and asks for admin permissions.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "This script needs admin privileges..." -ForegroundColor DarkRed
    Exit
} else {Write-Verbose -Message "Admin privileges found."}

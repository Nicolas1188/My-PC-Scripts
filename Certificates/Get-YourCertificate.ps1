<#
    .SYNOPSIS
        This script gives self-signed certificates to sign code.
    .DESCRIPTION
        This script creates the certificates, exports them to $PSCriptRoot,
        Then installs them as trusted.
    .PARAMETER Emails
        This is an array of strings, the emails use as -DnsName.
    .PARAMETER KeepCertificates
        When this switch is activated, the file doesn't delete the exported certificates.
    .INPUTS
        Strings, Switch
    .EXAMPLE
        .\Get-YourCertificate.ps1 -email@example.com
    .EXAMPLE
        .\Get-YourCertificate.ps1 -email@example.com -KeepCertificates
    .NOTES
        Author: @Nicolas1188
#>
# This script was written by @Nicolas1188 to get a Code Signing Certificate using your e-mail address.

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

[cmdletbinding()]
param (

    # This parameter is required for this script to work
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string[]] $Emails,
    [Parameter()][switch] $KeepCertificates

)

# Push-Location & Pop-Location are used so that you can run this cript form any directory.
Push-Location

# This part of the script checks and asks for admin permissions.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "This script needs admin privileges." -ForegroundColor DarkRed
    Exit
}

Set-Location $PSScriptRoot
Write-Output "You'll be getting a certificate issued to the email/s you submitted." "Note that you may be prompted to install this/these certificate."

foreach ($Email in $Emails) {

    Write-Host "---------------------------------------------------------------------------------------------------------------" -ForegroundColor Blue
    Write-Output "" "Working on $email." ""

    <#  First, it creates the certificate.
        Then, exports the profile to the folder where this script is located.
        Then, it imports it as a trusted publisher, and then as a root certificate authority.
        Afterwards, it will clean up the exported file. #>

    Write-Verbose -Message "Creating certificate..."
    New-SelfSignedCertificate -DnsName $email -Type CodeSigning -CertStoreLocation cert:\CurrentUser\My

    Write-Verbose -Message "Exporting certificate..."
    Export-Certificate -Cert (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)[0] -FilePath "$Email.crt"

    Write-Verbose -Message "Adding certificate as a trusted publisher..."
    Import-Certificate -FilePath ".\$Email.crt" -Cert Cert:\CurrentUser\TrustedPublisher

    Write-Verbose -Message "Installing certificate..."
    Import-Certificate -FilePath ".\$Email.crt" -Cert Cert:\CurrentUser\Root

    Write-Verbose -Message "Cleaning up..."
    if (!$KeepCertificates) {Remove-Item -Path ".\$Email.crt"}
    
    Write-Output "" "Your certificate has been installed in the current user." ""
    Write-Host "---------------------------------------------------------------------------------------------------------------" -ForegroundColor Blue

}

Pop-Location

# This file's repository is: https://github.com/Nicolas1188/My-PC-Share.git
# Thanks for downloading, and enjoy!

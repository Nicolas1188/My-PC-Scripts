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

# MIT License

# Copyright (c) 2020 nico-castell

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

# Thanks for downloading, and enjoy!

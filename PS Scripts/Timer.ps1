[CmdletBinding(DefaultParameterSetName='Seconds')]
param (
    [Parameter(Mandatory=$true,ParameterSetName='Hour')]
    [Int32] $Hours,
    [Parameter(Mandatory=$true,ParameterSetName='Minutes')]
    [Int32] $Minutes,
    [Parameter(Mandatory=$true,ParameterSetName='Seconds')]
    [Int32] $Seconds
)

#region Timers
#===========================================================================
if (!$Hours -eq 0) {
    $Time = $Hours -1
    for ($Hr = $Time; $Hr -gt -1; $Hr--) {
        for ($Min = 59; $Min -gt -1; $Min--) {
            for ($Sec = 59; $Sec -gt -1; $Sec--) {
                $var = ("{0}:{1}:{2}" -f ("{0:d2}" -f $Hr), ("{0:d2}" -f $Min), ("{0:d2}" -f $Sec))
                Write-Host -NoNewline "`rRemaining: $var"
                Start-Sleep -Seconds 1
            }
        }
    }
} elseif (!$Minutes -eq 0) {
    $Time = $Minutes - 1
    for ($Min = $Time; $Min -gt -1; $Min--) {
        for ($Sec = 59; $Sec -gt -1; $Sec--) {
            $var = ("{0}:{1}" -f ("{0:d2}" -f $Min), ("{0:d2}" -f $Sec))
            Write-Host -NoNewline "`rRemaining: $var"
            Start-Sleep -Seconds 1
        }
        
    }
} elseif (!$Seconds -eq 0) {
    $Time = $Seconds - 1
    for ($Sec = $Time; $Sec -gt -1; $Sec--) {
        $var = ("{0:d2}" -f $Sec)
        Write-Host -NoNewline "`rRemaining: $var"
        Start-Sleep -Seconds 1
    }
} else {Write-Error -Message "Something went wrong..."}
#===========================================================================
#endregion Timers

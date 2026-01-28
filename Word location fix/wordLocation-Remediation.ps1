$regEntries = @(
    @{ #Require geolocation setting to be disabled in Edge WebView2
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\WebView2"
        Name = "DefaultGeolocationSetting"
        Value = 3
        Type = "DWORD"
    }
)
Start-Transcript -Path "C:\Users\Public\Documents\Remediation-Scripts.log" -Append
Write-Output "Begin Remediation Script SecRegistrySettings"
Write-Output "----------------------------------------------------------------"

foreach ($regEntry in $regEntries) {
        $check = (get-itemproperty -Path $regEntry.Path -Name $regEntry.Name -ErrorAction SilentlyContinue).($regEntry.Name)
        if ($check -ne $regEntry.Value){
            Write-Output "Applying remediation for $($regEntry.Path) - $($regEntry.Name)"
            If (!(Test-Path $regEntry.Path)) {
                Write-Output "Registry path $($regEntry.Path) does not exist. Creating it now."
                New-Item -Path $regEntry.Path -Force -ErrorAction stop
            }
            if (Get-ItemProperty -Path $regEntry.Path -Name $regEntry.Name -ErrorAction SilentlyContinue) {
                Write-Output "Registry entry $($regEntry.Name) exists. Modifying its value now."
                Set-ItemProperty @regEntry -ErrorAction stop
            } else {
                Write-Output "Registry entry $($regEntry.Name) does not exist. Creating it now."
                New-ItemProperty @regEntry -ErrorAction stop
            }
            Write-Output "----------------------------------------------------------------"
        } else {
            Write-Output "No remediation applied for $($regEntry.Path) - $($regEntry.Name)"
            Write-Output "----------------------------------------------------------------"
        }
}
Stop-Transcript
exit 0 #Remediation complete
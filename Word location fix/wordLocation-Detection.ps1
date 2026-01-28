$regEntries = @(
    @{ #Require geolocation setting to be disabled in Edge WebView2
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\WebView2"
        Name = "DefaultGeolocationSetting"
        Value = 3
        Type = "DWORD"
    }
)
Start-Transcript -Path "C:\Users\Public\Documents\Remediation-Scripts.log" -Append
Write-Output "Begin Detection Script SecRegistrySettings"
Write-Output "----------------------------------------------------------------"

foreach ($regEntry in $regEntries) {
    $check = (get-itemproperty -Path $regEntry.Path -Name $regEntry.Name -ErrorAction SilentlyContinue).($regEntry.Name)
    if ($check -ne $regEntry.Value){
        Write-Output "Remediation required for $($regEntry.Path) - $($regEntry.Name)"
        Exit 1 #remediation required
    }
    Write-Output "No remediation required for $($regEntry.Path) - $($regEntry.Name)"
    Write-Output "----------------------------------------------------------------"
}
Write-Output "No detections found. Remediation Script will not be run."
Stop-Transcript
exit 0 #remediation not required

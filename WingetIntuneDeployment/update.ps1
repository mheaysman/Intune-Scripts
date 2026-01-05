$registryPath = "HKLM:\SOFTWARE\Winget"

try {
    winget --info
    $cmdlet = "winget"
    Write-Host "Winget found"
}
catch {
    Write-Host "Winget not found and must be located"
    Write-Host "Attempting to locate Winget"
    try {
        $wingetFolder = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe" -ErrorAction Stop
        Set-Location $wingetFolder[-1].Path -ErrorAction Stop
        $cmdlet = ".\winget.exe"
        "$($cmdlet) --info" |Invoke-Expression
    }
    catch {
        Throw "Error finding Winget folder. Make sure winget is installed on this device"
        Exit 1601
    }
    Write-Host "Winget folder found: $($wingetFolder[-1].Path)"
}

Get-Item $registryPath | foreach-object { $_.Property | foreach-object { "$($cmdlet) update $($_) $(get-itemproperty $registryPath -name $_ | Select-Object -expand $_)" | Write-Host } }

Get-Item $registryPath | foreach-object { $_.Property | foreach-object { "$($cmdlet) update $($_) $(get-itemproperty $registryPath -name $_ | Select-Object -expand $_)" | Invoke-Expression } }
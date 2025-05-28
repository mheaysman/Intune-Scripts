#Winget Intune Deployment
#Script from https://github.com/mheaysman/Intune-Scripts 
<# Example Usage:
.\wingetInstaller.ps1 -scope User -packageName Adobe.Acrobat 
.\wingetInstaller.ps1 -scope Machine -packageName Adobe.Acrobat -mode uninstall
#>
[CmdletBindings()]
param(
    [string]$packageName = "Adobe.Acrobat",
    [string]$scope = "Machine",
    [string]$mode = "install"
)
$logsfolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$dateTime = Get-Date -Format "yyyyMMdd-HHmmss"

Start-Transcript -Path "$($logsfolder)\Winget_$($packageName)_$($mode)_$($dateTime).log" -Append
Write-Host "Checking provided parameters are valid"

Write-Host "Mode Selected: $($mode)"
if ($mode -eq "install" -Or $mode -eq "uninstall"){
    Write-Host "Selected mode is valid"
}
else{
    Write-Host "Invalid value '$($mode)' provided for parameter 'mode'"
    Write-Host "Value must be 'install', 'uninstall' or not provided (default install)"
    Write-Host "Exiting..."
    Exit 87
}

Write-Host "Scope Selected: $($scope)"
if ($mode -eq "Machine"){
    Write-Host "Winget "
    
    Write-Host "Attempting to find Winget"
    try {
        $wingetFolder = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        Set-Location $wingetFolder[-1].Path
        $cmdlet = ".\winget.exe"
    }
    catch {
        Throw "Error finding Winget folder. Make sure winget is installed on this device"
        Write-Host "Exiting..."
        Exit 1601
    }
    Write-Host "Winget folder found: $($wingetFolder[-1].Path)"

}
elseif ($mode -eq "User") {
    $cmdlet = "winget"
}
else { 
    Write-Host "Invalid value '$($scope)' provided for parameter 'scope'"
    Write-Host "Value must be 'User', 'Machine' or not provided (default Machine)"
    Write-Host "Exiting..."
    Exit 87
}

Write-Host "preparing to $($mode) $($packageName)"
try {
    $command = "$($cmdlet) $($mode) $($packageName) --silent --accept-source-agreements --accept-package-agreements --Scope $($scope)"
    Invoke-Expression $command
}
catch {
    Throw "Error while attempting to $($mode) $($packageName)"
    Write-Host "Exiting..."
    Exit 1603
}

Write-Host "$($mode) of $($packageName) complete"
Write-Host "Exiting..."
Exit 0
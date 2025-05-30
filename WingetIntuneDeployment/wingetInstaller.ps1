<#  Winget Intune Deployment
    Get the latest version from from https://github.com/mheaysman/Intune-Scripts 

Use the below commands to ensure 64-bit powershell is used by intune - required for the Registry update
Install Command:
    %windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy ByPass -File .\wingetInstaller.ps1 -scope Machine -packageName Adobe.Acrobat.Reader.64-bit -mode install
Uninstall Command:
    %windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy ByPass -File .\wingetInstaller.ps1 -scope Machine -packageName Adobe.Acrobat.Reader.64-bit -mode uninstall
Detection:
    Detect via Registry, using the below details:
    Key path: HKEY_LOCAL_MACHINE\SOFTWARE\Winget
    Value Name: Package name (e.g. Adobe.Acrobat.Reader.64-bit)
    Detection Method: String Comparison
    Operator: Equals
    Value: install
    Associate with 32-bit app: No
#>
[CmdletBinding()]
param(
    [string]$packageName = "Adobe.Acrobat.Reader.64-bit",
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
    Write-Host "Value must be 'install', 'uninstall' or not provided (default install)"
    Exit 87
}

Write-Host "Scope Selected: $($scope)"
if ($scope -eq "Machine"){
    Write-Host "Winget must be located"
    
    Write-Host "Attempting to find Winget"
    try {
        $wingetFolder = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        Set-Location $wingetFolder[-1].Path
        $cmdlet = ".\winget.exe"
    }
    catch {
        Throw "Error finding Winget folder. Make sure winget is installed on this device"
        Exit 1601
    }
    Write-Host "Winget folder found: $($wingetFolder[-1].Path)"

}
elseif ($scope -eq "User") {
    $cmdlet = "winget"
}
else { 
    Write-Host "Value must be 'User', 'Machine' or not provided (default Machine)"
    Exit 87
}

Write-Host "Preparing to $($mode) $($packageName)"
try {
    $command = "$($cmdlet) $($mode) $($packageName) --silent --accept-source-agreements --accept-package-agreements --Scope $($scope)"
    Invoke-Expression $command
}
catch {
    Throw "Error while attempting to $($mode) $($packageName)"
    Exit 1603
}

Write-Host "$($mode) of $($packageName) complete"
Write-Host "creating/updating Registry Entry"

try {
    New-Item -Path "HKLM:\SOFTWARE\Winget" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Winget" -Name "$($packageName)" -Value "$($mode)" -Force
}
catch {
    Throw "Error creating/updating registry entry"
    Exit 1
}

Write-Host "Registry Entry created"
Write-Host "Installation completed"
Exit 0
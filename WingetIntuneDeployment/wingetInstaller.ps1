#Winget Intune Deployment
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

Write-Host "Find the latest version of this script and more at https://github.com/mheaysman/Intune-Scripts"

$dateTime = Get-Date -Format "yyyy-MM-dd-HHmmss"

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Winget_$($packageName)_$($mode)_$($dateTime).log" -Append

#Stop process if an invalid mode has been selected.
if ($mode -ne "install" -And $mode -ne "uninstall"){
    Write-Host "Invalid value '$($mode)' provided for parameter 'mode'"
    Write-Host "Exiting..."
    Stop-Transcript
    Exit 1
}

#Attempt to find the Folder containing Winget.exe and navigate there
try {
    $wingetFolder = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    Set-Location $wingetFolder[-1].Path
}
catch {
    Throw "Error finding Winget folder. Make sure winget is installed on this device"
    Write-Host "Exiting..."
    Stop-Transcript
    Exit 1
}

#install/uninstall the selected package
try {
    Write-Host "preparing to $($mode) $($packageName)"
    .\winget.exe $mode $packageName --silent --accept-source-agreements --accept-package-agreements --Scope $scope
    Write-Host "Completed $($mode) of $($packageName)"
}
catch {
    Throw "Error while attempting to $($mode) $($packageName)"
    Write-Host "Exiting..."
    Stop-Transcript
    Exit 1
}

Stop-Transcript
Exit 0
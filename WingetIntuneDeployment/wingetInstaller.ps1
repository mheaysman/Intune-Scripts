<#  Winget Intune Deployment
Get the latest version from https://github.com/mheaysman/Intune-Scripts 

Requires Windows 11 23H2 or greater, unless winget has been installed.

Install Command
%windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy ByPass -File .\wingetInstaller.ps1 -scope Machine -packageName Adobe.Acrobat.Reader.64-bit -mode install
%windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy ByPass -File .\wingetInstaller.ps1 -packageName Adobe.Acrobat.Reader.64-bit

Uninstall Command
%windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy ByPass -File .\wingetInstaller.ps1 -scope Machine -packageName Adobe.Acrobat.Reader.64-bit -mode uninstall

Detection:
Detect via Registry, using the below details:
 - Key path: HKEY_LOCAL_MACHINE\SOFTWARE\Winget
 - Value Name: Package name (e.g. Adobe.Acrobat.Reader.64-bit)
 - Detection Method: String Comparison
 - Operator: Equals
 - Value: install
 - Associate with 32-bit app: No
#>
[CmdletBinding()]
param(
    #default package to install
    [string]$packageName = "Adobe.Acrobat.Reader.64-bit",
    #default scope for installation
    [string]$scope = "Machine",
    #default mode (install/uninstall)
    [string]$mode = "install"
)
#Folder to store log file. By default, use intune logs folder
$logsfolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
#format for datetime stamp on log file
$dateTime = Get-Date -Format "yyyyMMdd-HHmmss"
#additional arguments for winget command
$additionalArgs = "--silent --accept-source-agreements"
#path for registry entries used for detection
$registryPath = "HKLM:\SOFTWARE\Winget"

#begin logging
Start-Transcript -Path "$($logsfolder)\Winget_$($packageName)_$($mode)_$($dateTime).log" -Append
Write-Host "Checking provided parameters are valid"

#check a valid mode was provided
Write-Host "Mode Selected: $($mode)"
if ($mode -eq "install"){
    $additionalArgs += " --accept-package-agreements"
    Write-Host "Accepting package agreements"
}
elseif ($mode -ne "uninstall"){
    Write-Host "Value must be 'install', 'uninstall' or not provided (default install)"
    Exit 87
}
Write-Host "Selected mode is valid"

#check selected scope
Write-Host "Scope Selected: $($scope)"
if ($scope -eq "Machine"){
    #Machine Context
}
elseif ($scope -eq "User") {
    #User Context
}
else { 
    Write-Host "Value must be 'User', 'Machine' or not provided (default Machine)"
    Exit 87
}

#check if Winget can be found
Write-Host "checking if Winget can be found"
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
        $infoCommand = "$($cmdlet) --info"
        Invoke-Expression $infoCommand
    }
    catch {
        Throw "Error finding Winget folder. Make sure winget is installed on this device"
        Exit 1601
    }
    Write-Host "Winget folder found: $($wingetFolder[-1].Path)"
}

#Start the install/uninstall via winget
Write-Host "Preparing to $($mode) $($packageName)"
try {
    $command = "$($cmdlet) $($mode) $($packageName) $($additionalArgs) --Scope $($scope)"
    Invoke-Expression $command
}
catch {
    Throw "Error while attempting to $($mode) $($packageName)"
    Exit 1603
}
Write-Host "$($mode) of $($packageName) complete"

#Create registry object if it does not exist
Write-Host "Checking if Registry object $($registryPath) exists"
try {
    Get-Item -Path $registryPath -ErrorAction Stop
    Write-Host "Found registry object: $($registryPath)"
}
catch {
    Write-Host "Did not find registry object: $($registryPath)"
    New-Item -Path $registryPath -Force
    Write-Host "Created new registry object: $($registryPath)"
}
#Create/update registry entry
Write-Host "creating/updating Registry Entry"
try {
    Set-ItemProperty -Path $registryPath -Name "$($packageName)" -Value "$($mode)" -Force  -ErrorAction Stop
}
catch {
    Throw "Error creating/updating registry entry"
    Exit 1
}

Write-Host "Registry Entry created"
Write-Host "Installation completed"
Stop-Transcript
Exit 0
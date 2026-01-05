#---------------------------------------Functions--------------------------------------#
function Compare-InstalledVersion {
    #Compares the installed version (if installed) to the the minimum required version
    param (
        [string]$regPath,
        [string]$MinVersion
    )
    if (Test-Path $regPath) {
        $rawVersion = (Get-ItemProperty $regPath).Version
        $cleanVersion = $rawVersion -replace "^v", ""  # Strip 'v' if present

        Write-Host "Detected version: $cleanVersion"
        Write-Host "Current  version: $MinVersion"

        # Compare using proper version casting
        if ([version]$cleanVersion -ge [version]"$($MinVersion)") {
            Write-Host "VC++ is up-to-date."
            return $false  # Compliant (up-to-date)
        }
        else {
            Write-Host "Updating to latest version..."
            return $true  # Non-compliant (outdated)
        }
    }
    else {
        Write-Host "VC++ x86 Redistributable not found."
        return $false  # Compliant (not installed)
    }
}
function Import-LatestVersion {
    #Downloads the latest version
    param (
        [string]$downloadUrl,
        [string]$installerPath
    )
    $retryCount = 0
    while ($retryCount -lt 3) {
        try {
            Write-Host "Downloading installer (Attempt $($retryCount + 1))..."
            Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
            Write-Host "Download completed."
            return $true
        }
        catch {
            $retryCount++
            Write-Host "Download failed. Retrying in 5 seconds..."
            Start-Sleep -Seconds 5
        }
    }
    Write-Host "Failed to download installer after 3 attempts."
    return $false
}
function Install-LatestVersion {
    #Installs the latest version
    param (
        [string]$installerPath
    )
    if (Test-Path $installerPath) {
        try {
            Write-Host "Starting update"
            Start-Process -FilePath $installerPath -ArgumentList "/install /quiet /norestart" -Wait -PassThru
            return $true
        }
        catch {
            throw "Failed to update VC++ Redistributable"
            return $false
        }
    }
    else {
        throw "Installer not found at $installerPath"
        return $false
    }
}
function Update-VCRedist {
    #Handles the overall update process
    param (
        [string]$MinVersion,
        [string]$LatestURL,
        [string]$regPath,
        [string]$InstallerPath
    )
    Write-Host "Checking $regPath"
    If (Compare-InstalledVersion -regPath $regPath -MinVersion $MinVersion) {
        If (Import-LatestVersion -downloadUrl $LatestURL -installerPath $InstallerPath) {
            If (Install-LatestVersion -installerPath $InstallerPath) {
                Write-Host "Update Complete. Removing Installer."
                Remove-Item -Path $InstallerPath -Force
                return $true
            }
        }
        Write-Host "Update failed. Removing Installer."
        Remove-Item -Path $InstallerPath -Force
        return $false
    }
    else {
        Write-Host "No update required."
        return $true
    }
}
#---------------------------------------Variables--------------------------------------#
#Set variables
$InstallerFolder = "C:\program files\temp\scripts"
$InstallerPath = "$($InstallerFolder)\vc_redist.exe"
$logsFolder = "C:\ProgramData\RDWA\Scripts\logs"
#array of VC++ redist versions to check for and update
$VCArray = @(
    @{
        MinVersion = "9.0.30729.5677" #EOS April 2018
        LatestURL  = "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\9.0\VC\VCRedist\X86"
    }, 
    @{
        MinVersion = "9.0.30729.5677" #EOS April 2018
        LatestURL  = "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\9.0\VC\VCRedist\X64"
    }, 
    @{
        MinVersion = "10.0.40219.325" #EOS July 2020
        LatestURL  = "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\10.0\VC\VCRedist\X86"
    }, 
    @{
        MinVersion = "10.0.40219.325" #EOS July 2020
        LatestURL  = "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\10.0\VC\VCRedist\X64"
    }, 
    @{
        MinVersion = "12.0.40664.0" #EOS April 2024
        LatestURL  = "https://aka.ms/highdpimfc2013x86enu"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\X86"
    }, 
    @{
        MinVersion = "12.0.40664.0" #EOS April 2024
        LatestURL  = "https://aka.ms/highdpimfc2013x64enu"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\X64"
    }, 
    @{
        MinVersion = "14.44.35211.0"
        LatestURL  = "https://aka.ms/vs/17/release/vc_redist.x86.exe"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\X86"
    }, 
    @{
        MinVersion = "14.44.35211.0"
        LatestURL  = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
        regPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\X64"
    }
)
#---------------------------------------Logging----------------------------------------#
#Check if logs folder exists, if not create it  
Write-Host "Checking if logs folder exists: $logsFolder"
if (!(Test-Path $logsFolder -PathType Container)) {
    Write-Host "Folder not found. Creating folder: $LogsFolder"
    New-Item -ItemType Directory -Force -Path $logsFolder
}
Start-Transcript -Path "$($logsFolder)\VCRedistUpdates_$(Get-Date -Format "yyyyMMdd-HHmmss").log"
#-------------------------------------Main Script--------------------------------------#
Write-Host "Starting VC++ Redistributable update process"

#Check if installer folder exists, if not create it
Write-Host "Checking if folder exists: $InstallerFolder"
if (!(Test-Path $InstallerFolder -PathType Container)) {
    Write-Host "Folder not found. Creating folder: $InstallerFolder"
    New-Item -ItemType Directory -Force -Path $InstallerFolder
}

#Process each VC++ version in the array
Write-Host "Versions to check:"
foreach ($VC in $VCArray) { Write-Host $VC.MinVersion }
foreach ($VC in $VCArray) { Update-VCRedist @VC -InstallerPath $InstallerPath }

Write-Host "VC++ Redistributable update process complete."
Stop-Transcript
Exit 0
#-------------------------------------END SCRIPT-------------------------------------#
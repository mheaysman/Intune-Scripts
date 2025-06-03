#run this to generate your own intunewin file for deployment.
#you will need to copy the IntuneWinAppUtil.exe into this directory to use it.

#config
$source = ".\WingetIntuneDeployment\"
$installer = "wingetInstaller.ps1"
$output = ".\"
$copyTo = "C:\Intune\files"

#Download URL for the Microsoft Win32 Content Prep Tool
$IntuneWinAppUtil = "https://raw.githubusercontent.com/microsoft/Microsoft-Win32-Content-Prep-Tool/master/IntuneWinAppUtil.exe"

#grab the latest version of the Microsoft Win32 Content Prep Tool
Invoke-WebRequest -Uri $IntuneWinAppUtil -OutFile .\IntuneWinAppUtil.exe -ErrorAction SilentlyContinue

#Package the Winget Script
.\IntuneWinAppUtil.exe -c $source -s $installer -o $output -q

#Clone the output file to a second location
Copy-Item -Path "$($output)wingetInstaller.intunewin" -Destination $copyTo -Force
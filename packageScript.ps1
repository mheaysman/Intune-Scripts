$source = ".\WingetIntuneDeployment\"
$installer = "wingetInstaller.ps1"
$output = ".\"
$copyTo = "C:\Intune\files"

.\IntuneWinAppUtil.exe -c $source -s $installer -o $output -q
Copy-Item -Path "$($output)wingetInstaller.intunewin" -Destination $copyTo -Force
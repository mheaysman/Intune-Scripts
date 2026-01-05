
#$parentFolder = "C:\temp\intune"
$parentFolder = $PSScriptRoot
$source = "$parentFolder\input"
$active = "$parentFolder\active"
$output = "$parentFolder\output"
$used = "$parentFolder\used"

#Create folders if needed
if (-not(Test-Path $active -PathType Container)) {
    New-Item -path $active -ItemType Directory
}
if (-not(Test-Path $output -PathType Container)) {
    New-Item -path $output -ItemType Directory
}
if (-not(Test-Path $used -PathType Container)) {
    New-Item -path $used -ItemType Directory
}


$installers = Get-ChildItem -Path $source

foreach ($installer in $installers) {
    move-Item -Path "$($source)\$($installer.Name)" -Destination $active -Force
    .\IntuneWinAppUtil.exe -c $active -s $installer -o $output -q
    Move-Item -Path "$($active)\$($installer.Name)" -Destination $used -Force
}

Read-Host "Packaging complete. Press Enter to exit."
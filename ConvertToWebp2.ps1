#Script to convert all images in a folder and subfolders to webp format using ImageMagick

function GetPath {
    Write-Host "Please provide the folder path in the format: C:\temp\images" -ForegroundColor Yellow
    $inputPath = Read-Host
    try {
        if (!(Test-Path -Path $inputPath)) {
            Write-Host "The provided folder cannot be found or does not exist. Please check the path and try again." -ForegroundColor Red
            return GetPath
        }
    }
    catch {
        Write-Host "An error occurred while validating the provided path. Please ensure the path is correct and try again." -ForegroundColor Red
        return GetPath 
    }

    Write-Host "Folder validation passed." -ForegroundColor Green
    Write-Host "All images in this folder will be converted to webp and the original files will be lost." -ForegroundColor Green
    Write-Host "Selected Folder: $($inputPath)" -ForegroundColor DarkGray

    Write-Host "Type '1' to start or press Enter to choose a different folder." -ForegroundColor Yellow
    $confirmPath = Read-Host
    if ($confirmPath -ne '1') {
        return GetPath
    }
    return $inputPath
}

function Orchestrator {

    Write-Host "Type '1' to convert images in '$($PSScriptRoot)' or press Enter to choose a different folder." -ForegroundColor Yellow
    $useCurrent = Read-Host
    if ($useCurrent -eq '1') {
        $directory = $PSScriptRoot
    }
    else {
        $directory = GetPath
    }

    $count = 0
    $inputformat = @('*.jpg', '*.png', '*.gif', '*.jpeg')

    $MagickFiles = (Get-Item "$env:ProgramFiles\ImageMagick*\magick.exe").VersionInfo | Sort-Object -Property FileVersionRaw
    $Magick = $MagickFiles[-1].FileName
    if (-not ($Magick)) {
        Write-Host "ImageMagick not found. Please ensure ImageMagick is installed before running this script." -ForegroundColor Red
        Write-Host "Press Enter to exit." -ForegroundColor Yellow
        Read-Host
        exit
    }

    Write-Host "Starting conversion of images to webp." -ForegroundColor Green
    foreach ($ext in $inputformat) {
        Get-ChildItem -Path $directory -File -Filter $ext -Recurse | ForEach-Object { 

            try {
                Write-Host "Converting $($_.FullName)" -ForegroundColor DarkGray
                & $Magick mogrify -format webp $_.FullName
                Remove-Item -Path $_.FullName -Force
                $count++
            }
            catch {
                Write-Host "Error converting $($_.FullName). File skipped." -ForegroundColor Red
                continue
            }
        }
    }
    Write-Host "Conversion complete. $($count) images were converted" -ForegroundColor Green

    Write-Host "Type '2' to convert another folder or press Enter to exit." -ForegroundColor Yellow
    $repeat = Read-Host
    if ($repeat -eq '2') { 
        Orchestrator
    }
}
Write-Host "Script by Max Heaysman - 2025." -ForegroundColor White
Write-Host "This script will convert all images in a folder to webp." -ForegroundColor Green
Write-Host "The original images will be lost, so make sure to have additional copies before proceeding." -ForegroundColor Green
Orchestrator

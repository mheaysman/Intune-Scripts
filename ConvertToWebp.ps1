

function GetPath {
    Write-Host "Please provide the folder path in the format: C:\temp\images" -ForegroundColor Yellow
    $inputPath = Read-Host

    if (!(Test-Path -Path $inputPath)) {
        Write-Host "The provided path does not exist. Please check the path and try again." -ForegroundColor Red
        return GetPath
    }
    return $inputPath
}

function ConvertImagesToWebp {
    $directory = GetPath
    $format = "webp"
    $inputformat = @('*.jpg', '*.png', '*.gif', '*.jpeg')

    Write-Host "Starting conversion of images in $directory to .$format" -ForegroundColor Green

    Get-ChildItem -Path $directory -Directory -Recurse | ForEach-Object { 
        Write-Host "Converting images in $($_.FullName)" -ForegroundColor DarkGray
        magick mogrify -format $format "$($_.FullName)\*" 
    }

    Write-Host "Conversion to .webp complete. Now deleting original files..." -ForegroundColor Green

    foreach ($ext in $inputformat) {
        Get-ChildItem -Path $directory -File -Filter $ext | Remove-Item -Force -WhatIf
        Get-ChildItem -Path $directory -Directory -Recurse | ForEach-Object {
            Get-ChildItem -Path "$($_.FullName)" -File -Filter $ext | Remove-Item -Force -WhatIf
        }
    }

    Get-ChildItem -Path $directory -Directory -Recurse | ForEach-Object { 
        Get-ChildItem -Path "$($_.FullName)" -File | Remove-Item -Force 
    }

    Write-Host "Conversion complete. Original files have been deleted." -ForegroundColor Green
    Write-Host "Type 'Y' to convert another folder or press Enter to exit." -ForegroundColor Yellow
    $repeat = Read-Host
    if ($repeat -eq 'Y') {
        ConvertImagesToWebp
    }
}

Write-Host "This script will convert all files in a folder and subfolders to .webp format." -ForegroundColor Green
Write-Host "Ensure you have ImageMagick installed and 'magick' is available in your system PATH." -ForegroundColor Green
Write-Host "------------------------------------------------------------------------------------"

Write-Host "This program will delete the original image files after converting to webp. " -ForegroundColor Red
#Write-Host "This INCLUDES any files that are not images." -ForegroundColor Red
Write-Host "Make sure you have backups before proceeding." -ForegroundColor Red
Write-Host "Please Type 'Y' to confirm the above." -ForegroundColor Yellow

$confirmation = Read-Host
if ($confirmation -eq 'Y') {
    ConvertImagesToWebp
}
else {
    Write-Host "No changes have been made." -ForegroundColor Green
    Write-Host "Press Enter to exit." -ForegroundColor Yellow
    Read-Host
    exit
}
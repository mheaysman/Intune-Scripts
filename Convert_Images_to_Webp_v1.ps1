#Script to convert all images in a folder and subfolders to webp format using ImageMagick

function GetPath {
    Write-Host "Please provide the folder path in the format: C:\temp\images" -ForegroundColor Yellow
    $inputPath = Read-Host

    if (!(Test-Path -Path $inputPath)) {
        Write-Host "The provided path does not exist. Please check the path and try again." -ForegroundColor Red
        return GetPath
    }
    return $inputPath
}

function Orchestrator {
    $directory = GetPath
    $format = "webp"
    $inputformat = @('*.jpg', '*.png', '*.gif', '*.jpeg')

    $MagickFiles = (Get-Item "$env:ProgramFiles\ImageMagick*\magick.exe").VersionInfo | Sort-Object -Property FileVersionRaw
    #If multiple versions, pick most recent one
    $Magick = $MagickFiles[-1].FileName
    $Magick

    Write-Host "Starting conversion of images in $directory to .$format" -ForegroundColor Green
    foreach ($ext in $inputformat) {
        Get-ChildItem -Path $directory -File -Filter $ext -Recurse | ForEach-Object { 
            Write-Host "Converting $($_.FullName)" -ForegroundColor DarkGray
            & $Magick mogrify -format $format $_.FullName
            Remove-Item -Path $_.FullName -Force
        }
    }
    Write-Host "Conversion complete. Original files have been deleted." -ForegroundColor Green

    Write-Host "Type 'Y' to convert another folder or press Enter to exit." -ForegroundColor Yellow
    $repeat = Read-Host
    if ($repeat -eq 'Y') { 
        Orchestrator
    }
}

Write-Host "This script will convert all images (jpeg, png and gif) in a folder and subfolders to .webp format." -ForegroundColor Green
Write-Host "Ensure you have ImageMagick installed and 'magick' is available in your system PATH." -ForegroundColor Green
Write-Host "------------------------------------------------------------------------------------"
Write-Host "This program will delete the original image files after converting to webp." -ForegroundColor Red
Write-Host "Make sure you have backups before proceeding." -ForegroundColor Red

Write-Host "Please Type 'Y' to confirm the above." -ForegroundColor Yellow
$confirmation = Read-Host
if ($confirmation -eq 'Y') {
    Orchestrator
}
else {
    Write-Host "No changes have been made." -ForegroundColor Green
    Write-Host "Press Enter to exit." -ForegroundColor Yellow
    Read-Host
    exit
}

















# SIG # Begin signature block
# MIIIIAYJKoZIhvcNAQcCoIIIETCCCA0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUS9vh6jGriNkj0u3yjxFW82iM
# kH2gggV/MIIFezCCBGOgAwIBAgITJQAAAJg8vSistkEn2gAAAAAAmDANBgkqhkiG
# 9w0BAQsFADBTMRgwFgYKCZImiZPyLGQBGRYISW50ZXJuYWwxGDAWBgoJkiaJk/Is
# ZAEZFghSdXJhbERvYzEdMBsGA1UEAxMUUnVyYWxEb2MtUkRXQUFTMDItQ0EwHhcN
# MjUwOTAxMDI0MTMyWhcNMjYwOTAxMDI0MTMyWjAaMRgwFgYDVQQDEw9SRFdBQ29k
# ZVNpZ25pbmcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDswoR+LSp/
# 3KvIfmvSPcjgSKeEe9hjK/SKq9z20ey8RogxWyIzIvyt7XzH4gUuvcuqk4SUNTc4
# tfqWmeOOiaNvadNM0t5SdxFwRU4p2VYmrHguEjj1mmsZZNFc7dL2ycykcKxPl+a+
# oIJ0PXM5+H0qw/4DUGbv1j8B8vhdTnMboTVg8MVnKQ90LwN+VaJh1OpVsUXDCHX2
# Siufs6JUJRytIn/+JVNGGbujtPuc2KjHQS0l5bafY+IJKYs6CtAHtil1FA7oUGev
# 9RZMf9nRxXcL/tdxqt9ACbYXI3f8VsmFdTLpy2l3XMgy2ihvzgG/B2qEYhNxLKqm
# F7ZtOtuNvl3tAgMBAAGjggJ/MIICezA+BgkrBgEEAYI3FQcEMTAvBicrBgEEAYI3
# FQiH9L9ChYrgEILBgzaGwr1YgZSZDIFcg6SLd4H5qVsCAWQCAQIwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwGwYJKwYB
# BAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQU48HeO0bAR7WTSYF0Z8TF
# HjT0dpIwHwYDVR0jBBgwFoAUyhT61yRRlIgAztYgPWnrZHZQUOcwgdkGA1UdHwSB
# 0TCBzjCBy6CByKCBxYaBwmxkYXA6Ly8vQ049UnVyYWxEb2MtUkRXQUFTMDItQ0Es
# Q049UkRXQUFTMDIsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENO
# PVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9UnVyYWxEb2MsREM9SW50ZXJu
# YWw/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNS
# TERpc3RyaWJ1dGlvblBvaW50MIHMBggrBgEFBQcBAQSBvzCBvDCBuQYIKwYBBQUH
# MAKGgaxsZGFwOi8vL0NOPVJ1cmFsRG9jLVJEV0FBUzAyLUNBLENOPUFJQSxDTj1Q
# dWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0
# aW9uLERDPVJ1cmFsRG9jLERDPUludGVybmFsP2NBQ2VydGlmaWNhdGU/YmFzZT9v
# YmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MA0GCSqGSIb3DQEBCwUA
# A4IBAQCUIK0ftgueQ1UDDPZdLg6wH/6pOxrBn39HZEFJr7+9Jt8gkWE3WdUg9AhL
# Y4YMC9d2zcTHGrUYRjfpIAW8SPl73daNm/LSlzaK5U2+Tu+nGJdGXxom0b5kj7o7
# ltnsbEKnkXAoxt+3gKTPP23c1MkKzc4l3UHj5/eQWT/Gbism8Wt/aKqgcq6+Nloy
# KSjzLNBNJCuIEq8ZpNB/EoIa+tMXuIr/TFYWVhZXaX/Mll8Dk5g9aCK1iH92l87O
# hKF5GKrPpUAoccVY7tsfTYscowld0oDUl/v6NstSphnupnExAeiyM17bELIjhg+8
# v9LPM0GOGqBJHQZuaPfQOYd8H7t/MYICCzCCAgcCAQEwajBTMRgwFgYKCZImiZPy
# LGQBGRYISW50ZXJuYWwxGDAWBgoJkiaJk/IsZAEZFghSdXJhbERvYzEdMBsGA1UE
# AxMUUnVyYWxEb2MtUkRXQUFTMDItQ0ECEyUAAACYPL0orLZBJ9oAAAAAAJgwCQYF
# Kw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkD
# MQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJ
# KoZIhvcNAQkEMRYEFLGoxwTQceu0bv1h3b3CfJS849WaMA0GCSqGSIb3DQEBAQUA
# BIIBAOmbeErWN4D69oit3UAFlQxPymV84hsvGVBVmI2Uk/nNl7ltFMdhebGyW80H
# 1uO5qTb4mRfC8zJrAy0Dkb2rmXsUBwa48tEArWRk4q3hs1VMoNXLKk+xD4nYao2L
# +qFjKypFydPf60dD53E/j4DN9/PojCPTOub8jcdA1OFEV/cq6bdDInX/YhCHqo0c
# rmO2gfD2cw1LVQtM+NZbsXwOlIqQmi+CIKvcC4tFckDON2M7fFJXfZQcKAu1HEXb
# 979SMg7LHkTPfpIi5wcagfuNFVJ8xYnWok6dcCyzuqM3MGGh9G9jiZYIa+Y4X6Mj
# K/zBHUfGwGq10RSdoln7W6KGoFs=
# SIG # End signature block

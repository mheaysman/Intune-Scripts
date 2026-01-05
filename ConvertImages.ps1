#Script to convert all images in a folder and subfolders to webp format using ImageMagick

function GetPath {
    Write-Host "Please provide the folder path in the format: C:\temp\images" -ForegroundColor Yellow
    $inputPath = Read-Host

    if (!(Test-Path -Path $inputPath)) {
        Write-Host "The provided folder cannot be found or does not exist. Please check the path and try again." -ForegroundColor Red
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
    $directory = GetPath
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

            try{
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

# SIG # Begin signature block
# MIIiDQYJKoZIhvcNAQcCoIIh/jCCIfoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCOCm3Jp3lKlfCV
# fNSMgQiYedI6hzVFBXir72nNSn+lM6CCHCAwggOZMIICgaADAgECAhBD2qLX+cQd
# lEn9jjUrxHHCMA0GCSqGSIb3DQEBCwUAMFMxGDAWBgoJkiaJk/IsZAEZFghJbnRl
# cm5hbDEYMBYGCgmSJomT8ixkARkWCFJ1cmFsRG9jMR0wGwYDVQQDExRSdXJhbERv
# Yy1SRFdBQVMwMi1DQTAeFw0yMzA4MDIyMzA1MjdaFw0yODA4MDIyMzE1MjZaMFMx
# GDAWBgoJkiaJk/IsZAEZFghJbnRlcm5hbDEYMBYGCgmSJomT8ixkARkWCFJ1cmFs
# RG9jMR0wGwYDVQQDExRSdXJhbERvYy1SRFdBQVMwMi1DQTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAKqz9ODhKVvJSZb997i9LxmL8B1hAVrnA263VLRx
# 6DRaV7SDv5acjzQ11JP/6oZ0UVqZ/cFzFuokYuMxZSi1W0ca4k19VgMcDkVUV/Li
# ooCdDnKbsBhXHpvjlp0R132W3StNWfvPnR4wgFVlQdCAjAUHh9SP7iLmMi9jonyb
# 7wSW3pLKMlj/tEI/h1ykYArheuSIQPRm6wEGtkVu1naqDADxLnl+LMqYRGu+Lu8e
# z0NkRUb0hYH9WqTv9WfNrSELxCOsT8u/8Y42TfNTqlyQeSg+JHAySzZHuxhYTJEC
# u3VHsMPpb3OW405D9rjx9cLvJTCqJ5oteHKaGwu5VDFnwukCAwEAAaNpMGcwEwYJ
# KwYBBAGCNxQCBAYeBABDAEEwDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMB
# Af8wHQYDVR0OBBYEFMoU+tckUZSIAM7WID1p62R2UFDnMBAGCSsGAQQBgjcVAQQD
# AgEAMA0GCSqGSIb3DQEBCwUAA4IBAQAUmFKlDud5Yjy+KNfWRvBDrT2zEP3XCtWr
# /PwtoviAqkKAnwxeTG6Qkksate40WOVkuTIH3igTr9Y0SnGOZbGNhJe5VitXSOFY
# j95QfWMIPai3z2hSLDmMRa5vn+uaosindNV1sMdBO7A7S6ehKrJkVrAVkwSKMBX0
# u0ZWoz6QP/HXnXPS3o8D6EtX4YFc86XFcR8mHdaCVQV2nSpRGF621rSOeikCtQ/h
# M62hX3cx5+JvidLYOQJKEDSD36SqlZjteEqZ59pthVJbD0ZRedGsNJnES4qMENHv
# 4fOSqfBHugM7KMttjdP1uGBcb4SeygTpJwEDgxEyQKeX0lqBuzP0MIIFezCCBGOg
# AwIBAgITJQAAAJg8vSistkEn2gAAAAAAmDANBgkqhkiG9w0BAQsFADBTMRgwFgYK
# CZImiZPyLGQBGRYISW50ZXJuYWwxGDAWBgoJkiaJk/IsZAEZFghSdXJhbERvYzEd
# MBsGA1UEAxMUUnVyYWxEb2MtUkRXQUFTMDItQ0EwHhcNMjUwOTAxMDI0MTMyWhcN
# MjYwOTAxMDI0MTMyWjAaMRgwFgYDVQQDEw9SRFdBQ29kZVNpZ25pbmcwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDswoR+LSp/3KvIfmvSPcjgSKeEe9hj
# K/SKq9z20ey8RogxWyIzIvyt7XzH4gUuvcuqk4SUNTc4tfqWmeOOiaNvadNM0t5S
# dxFwRU4p2VYmrHguEjj1mmsZZNFc7dL2ycykcKxPl+a+oIJ0PXM5+H0qw/4DUGbv
# 1j8B8vhdTnMboTVg8MVnKQ90LwN+VaJh1OpVsUXDCHX2Siufs6JUJRytIn/+JVNG
# GbujtPuc2KjHQS0l5bafY+IJKYs6CtAHtil1FA7oUGev9RZMf9nRxXcL/tdxqt9A
# CbYXI3f8VsmFdTLpy2l3XMgy2ihvzgG/B2qEYhNxLKqmF7ZtOtuNvl3tAgMBAAGj
# ggJ/MIICezA+BgkrBgEEAYI3FQcEMTAvBicrBgEEAYI3FQiH9L9ChYrgEILBgzaG
# wr1YgZSZDIFcg6SLd4H5qVsCAWQCAQIwEwYDVR0lBAwwCgYIKwYBBQUHAwMwDgYD
# VR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwGwYJKwYBBAGCNxUKBA4wDDAKBggr
# BgEFBQcDAzAdBgNVHQ4EFgQU48HeO0bAR7WTSYF0Z8TFHjT0dpIwHwYDVR0jBBgw
# FoAUyhT61yRRlIgAztYgPWnrZHZQUOcwgdkGA1UdHwSB0TCBzjCBy6CByKCBxYaB
# wmxkYXA6Ly8vQ049UnVyYWxEb2MtUkRXQUFTMDItQ0EsQ049UkRXQUFTMDIsQ049
# Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNv
# bmZpZ3VyYXRpb24sREM9UnVyYWxEb2MsREM9SW50ZXJuYWw/Y2VydGlmaWNhdGVS
# ZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBv
# aW50MIHMBggrBgEFBQcBAQSBvzCBvDCBuQYIKwYBBQUHMAKGgaxsZGFwOi8vL0NO
# PVJ1cmFsRG9jLVJEV0FBUzAyLUNBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBT
# ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPVJ1cmFsRG9j
# LERDPUludGVybmFsP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0
# aWZpY2F0aW9uQXV0aG9yaXR5MA0GCSqGSIb3DQEBCwUAA4IBAQCUIK0ftgueQ1UD
# DPZdLg6wH/6pOxrBn39HZEFJr7+9Jt8gkWE3WdUg9AhLY4YMC9d2zcTHGrUYRjfp
# IAW8SPl73daNm/LSlzaK5U2+Tu+nGJdGXxom0b5kj7o7ltnsbEKnkXAoxt+3gKTP
# P23c1MkKzc4l3UHj5/eQWT/Gbism8Wt/aKqgcq6+NloyKSjzLNBNJCuIEq8ZpNB/
# EoIa+tMXuIr/TFYWVhZXaX/Mll8Dk5g9aCK1iH92l87OhKF5GKrPpUAoccVY7tsf
# TYscowld0oDUl/v6NstSphnupnExAeiyM17bELIjhg+8v9LPM0GOGqBJHQZuaPfQ
# OYd8H7t/MIIGFDCCA/ygAwIBAgIQeiOu2lNplg+RyD5c9MfjPzANBgkqhkiG9w0B
# AQwFADBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS4w
# LAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJvb3QgUjQ2MB4X
# DTIxMDMyMjAwMDAwMFoXDTM2MDMyMTIzNTk1OVowVTELMAkGA1UEBhMCR0IxGDAW
# BgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJsaWMg
# VGltZSBTdGFtcGluZyBDQSBSMzYwggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGK
# AoIBgQDNmNhDQatugivs9jN+JjTkiYzT7yISgFQ+7yavjA6Bg+OiIjPm/N/t3nC7
# wYUrUlY3mFyI32t2o6Ft3EtxJXCc5MmZQZ8AxCbh5c6WzeJDB9qkQVa46xiYEpc8
# 1KnBkAWgsaXnLURoYZzksHIzzCNxtIXnb9njZholGw9djnjkTdAA83abEOHQ4ujO
# GIaBhPXG2NdV8TNgFWZ9BojlAvflxNMCOwkCnzlH4oCw5+4v1nssWeN1y4+RlaOy
# wwRMUi54fr2vFsU5QPrgb6tSjvEUh1EC4M29YGy/SIYM8ZpHadmVjbi3Pl8hJiTW
# w9jiCKv31pcAaeijS9fc6R7DgyyLIGflmdQMwrNRxCulVq8ZpysiSYNi79tw5RHW
# ZUEhnRfs/hsp/fwkXsynu1jcsUX+HuG8FLa2BNheUPtOcgw+vHJcJ8HnJCrcUWhd
# Fczf8O+pDiyGhVYX+bDDP3GhGS7TmKmGnbZ9N+MpEhWmbiAVPbgkqykSkzyYVr15
# OApZYK8CAwEAAaOCAVwwggFYMB8GA1UdIwQYMBaAFPZ3at0//QET/xahbIICL9AK
# PRQlMB0GA1UdDgQWBBRfWO1MMXqiYUKNUoC6s2GXGaIymzAOBgNVHQ8BAf8EBAMC
# AYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEFBQcDCDARBgNV
# HSAECjAIMAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5zZWN0
# aWdvLmNvbS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nUm9vdFI0Ni5jcmwwfAYI
# KwYBBQUHAQEEcDBuMEcGCCsGAQUFBzAChjtodHRwOi8vY3J0LnNlY3RpZ28uY29t
# L1NlY3RpZ29QdWJsaWNUaW1lU3RhbXBpbmdSb290UjQ2LnA3YzAjBggrBgEFBQcw
# AYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBABLX
# eyCtDjVYDJ6BHSVY/UwtZ3Svx2ImIfZVVGnGoUaGdltoX4hDskBMZx5NY5L6SCcw
# DMZhHOmbyMhyOVJDwm1yrKYqGDHWzpwVkFJ+996jKKAXyIIaUf5JVKjccev3w16m
# NIUlNTkpJEor7edVJZiRJVCAmWAaHcw9zP0hY3gj+fWp8MbOocI9Zn78xvm9XKGB
# p6rEs9sEiq/pwzvg2/KjXE2yWUQIkms6+yslCRqNXPjEnBnxuUB1fm6bPAV+Tsr/
# Qrd+mOCJemo06ldon4pJFbQd0TQVIMLv5koklInHvyaf6vATJP4DfPtKzSBPkKlO
# tyaFTAjD2Nu+di5hErEVVaMqSVbfPzd6kNXOhYm23EWm6N2s2ZHCHVhlUgHaC4AC
# MRCgXjYfQEDtYEK54dUwPJXV7icz0rgCzs9VI29DwsjVZFpO4ZIVR33LwXyPDbYF
# kLqYmgHjR3tKVkhh9qKV2WCmBuC27pIOx6TYvyqiYbntinmpOqh/QPAnhDgexKG9
# GX/n1PggkGi9HCapZp8fRwg8RftwS21Ln61euBG0yONM6noD2XQPrFwpm3GcuqJM
# f0o8LLrFkSLRQNwxPDDkWXhW+gZswbaiie5fd/W2ygcto78XCSPfFWveUOSZ5SqK
# 95tBO8aTHmEa4lpJVD7HrTEn9jb1EGvxOb1cnn0CMIIGYjCCBMqgAwIBAgIRAKQp
# O24e3denNAiHrXpOtyQwDQYJKoZIhvcNAQEMBQAwVTELMAkGA1UEBhMCR0IxGDAW
# BgNVBAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJsaWMg
# VGltZSBTdGFtcGluZyBDQSBSMzYwHhcNMjUwMzI3MDAwMDAwWhcNMzYwMzIxMjM1
# OTU5WjByMQswCQYDVQQGEwJHQjEXMBUGA1UECBMOV2VzdCBZb3Jrc2hpcmUxGDAW
# BgNVBAoTD1NlY3RpZ28gTGltaXRlZDEwMC4GA1UEAxMnU2VjdGlnbyBQdWJsaWMg
# VGltZSBTdGFtcGluZyBTaWduZXIgUjM2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
# MIICCgKCAgEA04SV9G6kU3jyPRBLeBIHPNyUgVNnYayfsGOyYEXrn3+SkDYTLs1c
# rcw/ol2swE1TzB2aR/5JIjKNf75QBha2Ddj+4NEPKDxHEd4dEn7RTWMcTIfm492T
# W22I8LfH+A7Ehz0/safc6BbsNBzjHTt7FngNfhfJoYOrkugSaT8F0IzUh6VUwoHd
# YDpiln9dh0n0m545d5A5tJD92iFAIbKHQWGbCQNYplqpAFasHBn77OqW37P9BhOA
# Sdmjp3IijYiFdcA0WQIe60vzvrk0HG+iVcwVZjz+t5OcXGTcxqOAzk1frDNZ1aw8
# nFhGEvG0ktJQknnJZE3D40GofV7O8WzgaAnZmoUn4PCpvH36vD4XaAF2CjiPsJWi
# Y/j2xLsJuqx3JtuI4akH0MmGzlBUylhXvdNVXcjAuIEcEQKtOBR9lU4wXQpISrbO
# T8ux+96GzBq8TdbhoFcmYaOBZKlwPP7pOp5Mzx/UMhyBA93PQhiCdPfIVOCINsUY
# 4U23p4KJ3F1HqP3H6Slw3lHACnLilGETXRg5X/Fp8G8qlG5Y+M49ZEGUp2bneRLZ
# oyHTyynHvFISpefhBCV0KdRZHPcuSL5OAGWnBjAlRtHvsMBrI3AAA0Tu1oGvPa/4
# yeeiAyu+9y3SLC98gDVbySnXnkujjhIh+oaatsk/oyf5R2vcxHahajMCAwEAAaOC
# AY4wggGKMB8GA1UdIwQYMBaAFF9Y7UwxeqJhQo1SgLqzYZcZojKbMB0GA1UdDgQW
# BBSIYYyhKjdkgShgoZsx0Iz9LALOTzAOBgNVHQ8BAf8EBAMCBsAwDAYDVR0TAQH/
# BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBKBgNVHSAEQzBBMDUGDCsGAQQB
# sjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3RpZ28uY29tL0NQUzAI
# BgZngQwBBAIwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL2NybC5zZWN0aWdvLmNv
# bS9TZWN0aWdvUHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3JsMHoGCCsGAQUFBwEB
# BG4wbDBFBggrBgEFBQcwAoY5aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdv
# UHVibGljVGltZVN0YW1waW5nQ0FSMzYuY3J0MCMGCCsGAQUFBzABhhdodHRwOi8v
# b2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEAAoE+pIZyUSH5Zaku
# PVKK4eWbzEsTRJOEjbIu6r7vmzXXLpJx4FyGmcqnFZoa1dzx3JrUCrdG5b//LfAx
# OGy9Ph9JtrYChJaVHrusDh9NgYwiGDOhyyJ2zRy3+kdqhwtUlLCdNjFjakTSE+hk
# C9F5ty1uxOoQ2ZkfI5WM4WXA3ZHcNHB4V42zi7Jk3ktEnkSdViVxM6rduXW0jmmi
# u71ZpBFZDh7Kdens+PQXPgMqvzodgQJEkxaION5XRCoBxAwWwiMm2thPDuZTzWp/
# gUFzi7izCmEt4pE3Kf0MOt3ccgwn4Kl2FIcQaV55nkjv1gODcHcD9+ZVjYZoyKTV
# Wb4VqMQy/j8Q3aaYd/jOQ66Fhk3NWbg2tYl5jhQCuIsE55Vg4N0DUbEWvXJxtxQQ
# aVR5xzhEI+BjJKzh3TQ026JxHhr2fuJ0mV68AluFr9qshgwS5SpN5FFtaSEnAwqZ
# v3IS+mlG50rK7W3qXbWwi4hmpylUfygtYLEdLQukNEX1jiOKMIIGgjCCBGqgAwIB
# AgIQNsKwvXwbOuejs902y8l1aDANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4w
# HAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVz
# dCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjEwMzIyMDAwMDAwWhcN
# MzgwMTE4MjM1OTU5WjBXMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBM
# aW1pdGVkMS4wLAYDVQQDEyVTZWN0aWdvIFB1YmxpYyBUaW1lIFN0YW1waW5nIFJv
# b3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAiJ3YuUVnnR3d
# 6LkmgZpUVMB8SQWbzFoVD9mUEES0QUCBdxSZqdTkdizICFNeINCSJS+lV1ipnW5i
# hkQyC0cRLWXUJzodqpnMRs46npiJPHrfLBOifjfhpdXJ2aHHsPHggGsCi7uE0awq
# KggE/LkYw3sqaBia67h/3awoqNvGqiFRJ+OTWYmUCO2GAXsePHi+/JUNAax3kpqs
# tbl3vcTdOGhtKShvZIvjwulRH87rbukNyHGWX5tNK/WABKf+Gnoi4cmisS7oSimg
# HUI0Wn/4elNd40BFdSZ1EwpuddZ+Wr7+Dfo0lcHflm/FDDrOJ3rWqauUP8hsokDo
# I7D/yUVI9DAE/WK3Jl3C4LKwIpn1mNzMyptRwsXKrop06m7NUNHdlTDEMovXAIDG
# AvYynPt5lutv8lZeI5w3MOlCybAZDpK3Dy1MKo+6aEtE9vtiTMzz/o2dYfdP0KWZ
# wZIXbYsTIlg1YIetCpi5s14qiXOpRsKqFKqav9R1R5vj3NgevsAsvxsAnI8Oa5s2
# oy25qhsoBIGo/zi6GpxFj+mOdh35Xn91y72J4RGOJEoqzEIbW3q0b2iPuWLA911c
# RxgY5SJYubvjay3nSMbBPPFsyl6mY4/WYucmyS9lo3l7jk27MAe145GWxK4O3m3g
# EFEIkv7kRmefDR7Oe2T1HxAnICQvr9sCAwEAAaOCARYwggESMB8GA1UdIwQYMBaA
# FFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBT2d2rdP/0BE/8WoWyCAi/Q
# Cj0UJTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUEDDAK
# BggrBgEFBQcDCDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/
# aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRp
# b25BdXRob3JpdHkuY3JsMDUGCCsGAQUFBwEBBCkwJzAlBggrBgEFBQcwAYYZaHR0
# cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEADr5lQe1o
# RLjlocXUEYfktzsljOt+2sgXke3Y8UPEooU5y39rAARaAdAxUeiX1ktLJ3+lgxto
# LQhn5cFb3GF2SSZRX8ptQ6IvuD3wz/LNHKpQ5nX8hjsDLRhsyeIiJsms9yAWnvdY
# OdEMq1W61KE9JlBkB20XBee6JaXx4UBErc+YuoSb1SxVf7nkNtUjPfcxuFtrQdRM
# Ri/fInV/AobE8Gw/8yBMQKKaHt5eia8ybT8Y/Ffa6HAJyz9gvEOcF1VWXG8OMeM7
# Vy7Bs6mSIkYeYtddU1ux1dQLbEGur18ut97wgGwDiGinCwKPyFO7ApcmVJOtlw9F
# VJxw/mL1TbyBns4zOgkaXFnnfzg4qbSvnrwyj1NiurMp4pmAWjR+Pb/SIduPnmFz
# bSN/G8reZCL4fvGlvPFk4Uab/JVCSmj59+/mB2Gn6G/UYOy8k60mKcmaAZsEVkhO
# Fuoj4we8CYyaR9vd9PGZKSinaZIkvVjbH/3nlLb0a7SBIkiRzfPfS9T+JesylbHa
# 1LtRV9U/7m0q7Ma2CQ/t392ioOssXW7oKLdOmMBl14suVFBmbzrt5V5cQPnwtd3U
# OTpS9oCG+ZZheiIvPgkDmA8FzPsnfXW5qHELB43ET7HHFHeRPRYrMBKjkb8/IN7P
# o0d0hQoF4TeMM+zYAJzoKQnVKOLg8pZVPT8xggVDMIIFPwIBATBqMFMxGDAWBgoJ
# kiaJk/IsZAEZFghJbnRlcm5hbDEYMBYGCgmSJomT8ixkARkWCFJ1cmFsRG9jMR0w
# GwYDVQQDExRSdXJhbERvYy1SRFdBQVMwMi1DQQITJQAAAJg8vSistkEn2gAAAAAA
# mDANBglghkgBZQMEAgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMC8GCSqGSIb3DQEJBDEiBCC8ElnfXZ/3S8BVIbtzQzpmsmHMK4J6kBgm
# EPsc3jgk+zANBgkqhkiG9w0BAQEFAASCAQAZRtO7JBvcFXhdPBbbM97VIx5OyioA
# vXrDRbUgsN7v3Dn5/wZ3TcFOWoB4huSaR85I2AQr/49qJP9dbNGQCHXOnqD9m0Af
# 7ac3ZWOu0PW9aJrrMLRcjnBL4xlyPKfaol6EJxpW4SrxZ17nM9JnnhEGMsYWL16Y
# VmTXATXOQGQ7cWMnez3K9QRRYH+lTeLCFecn9HgWXHkVzX12rD1ZDBu/psloU2WR
# cZBp6qwWVokPtBuacseAbfMaI3W05AapWhhbVgQ2SDnMgjfwu05WXZ/oblC4mfbU
# lv9Q4xxE9B6XGVEZrS9rnm4cU+Cq16fJkUVwEdtsejlYQExluMkApt8ZoYIDIzCC
# Ax8GCSqGSIb3DQEJBjGCAxAwggMMAgEBMGowVTELMAkGA1UEBhMCR0IxGDAWBgNV
# BAoTD1NlY3RpZ28gTGltaXRlZDEsMCoGA1UEAxMjU2VjdGlnbyBQdWJsaWMgVGlt
# ZSBTdGFtcGluZyBDQSBSMzYCEQCkKTtuHt3XpzQIh616TrckMA0GCWCGSAFlAwQC
# AgUAoHkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MjUwOTMwMDY0MjE4WjA/BgkqhkiG9w0BCQQxMgQweAdWFF1ouu+46PS43s09G4mu
# 1Kyp4HVouOGvKtEjqwFgHNTMKEbqUFeQngaX8WkOMA0GCSqGSIb3DQEBAQUABIIC
# ACLBDaBWBrivWsW4JPkclAjLvPPAMOvy16RqZQWCwAQdFIT9lDWmJw/kKcbgitw1
# L+tlF6x6WqdcwJg5ECIZgKuTd3pw/Trfh902wL3TSmXJjfCKndio3Hh7zUHtugkt
# wa9ytI9gudgMLSkql0gvP8KtX7J7taPYDf9kNoJREf69QNCgx22I9F9GyAz6jDbv
# Mm/Er/OGZPU2zpR0dfBykK6wylEDKHbxC+pKUCiwKrqZwLrGcc02dmQXeRekCOUK
# ze2PK3PPBSLV4IohaoGiobDTXN3QBNkxbRbFsRvs3fw72DMH7HvkwjMVPcMYc1ce
# 2d/y6dfECAPo49rSpLS53rPPa7rgI+Ia4VTpzoukL8iYZuvxsl4voY6Q3sq2AOOi
# G6NTnVAYxarC+Db1qWqibhEehTQlv5kzjDzvSn2Jtax5/+gyjbntyg0P7oTNlmqi
# 4egal/yWsxvCZ4Jpb9473rt1XRD/tSLb14VuLgcD/SqCD5bKIaHMD9CER5VPLdvL
# Ciajzb5Y2AjJKDsRKgOMe7+aSm4vBff49LdlZ2zETs2brKfdBnlHuj9PYxVh9yKs
# XsSOYHh/UYw4+B9RnteC1hzep/RQjUK2Ivjb6lalnbpc7ZoerVx7+UIQ31qMiHRR
# ioGn0KF9gVp8aYinFJ2SoqkzgVdddRDABOfy8CgIDEfp
# SIG # End signature block

#Various One-Liners or short scripts

# Magick (Image Manipulation tool) script to all images in subfolders to a specific format (does not convert images in the root folder)
# Requires Magick to be installed
$directory = "C:\path\to\images"
$format = "webp"
$filter = "*.jpg"
Get-ChildItem -Path $directory -Directory -Recurse | ForEach-Object {Write-Host "Converting: $($_.FullName)"; magick mogrify -format $format "$($_.FullName)\$($filter)"}
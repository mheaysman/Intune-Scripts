$Paths = @("HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown","HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown\")
$Key = "bDisableJavaScript"
$KeyFormat = "dword"
$Value = "1"
foreach ($Path in $Paths){
    if(!(Test-Path $Path)){
        New-Item -Path $Path -Force
    }
    if(!$Key){
        Set-Item -Path $Path -Value $Value
    }
    else{
        Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat
    }
}
$Paths = @("HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown","HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown\")
$Key = "bEnableFlash"
$KeyFormat = "dword"
$Value = "0"
foreach ($Path in $Paths){
    if(!(Test-Path $Path)){
        New-Item -Path $Path -Force
    }
    if(!$Key){
        Set-Item -Path $Path -Value $Value
    }
    else{
        Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat
    }
}
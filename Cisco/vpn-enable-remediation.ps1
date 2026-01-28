$VPNDisabled = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile\VPNDisable_ServiceProfile.xml"
$VPNProfile = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile\VPN_ServiceProfile.xml"
$profileXML = '<?xml version="1.0" encoding="UTF-8"?><AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.xmlsoap.org/encoding/ AnyConnectProfile.xsd"><ServerList><HostEntry><HostName>Rural Doctors Workforce Agency</HostName><HostAddress>azure-qhwtbncmvr.dynamic-m.com:4443</HostAddress></HostEntry></ServerList></AnyConnectProfile>'
try {
    if (Test-Path $VPNDisabled) {
    Remove-Item -Path $VPNDisabled -Force
}
if (!(Test-Path $VPNProfile)) {
    $profileXML | Out-File -FilePath $VPNProfile -Encoding UTF8
}
}
catch {
    exit 1
}

exit 0
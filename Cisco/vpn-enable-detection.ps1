$VPNDisabled = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile\VPNDisable_ServiceProfile.xml"
$VPNProfile = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile\VPN_ServiceProfile.xml"

if (Test-Path $VPNDisabled) {
    #remediate
    exit 1
} elseif (Test-Path $VPNProfile) {
    #no remediation needed"
    exit 0
} else {
    #remediate
    exit 1
}
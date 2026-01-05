

# Ensure the Lsa registry key exists
If (!Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'){
    New-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Force
} 
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'DisableDomainCreds' -Value 1 -PropertyType DWord -Force


If (!Get-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections'){
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections' -Force
}   
New-ItemProperty -Path 'HKLM:\\SOFTWARE\Policies\Microsoft\Windows\Network Connections' -Name 'NC_StdDomainUserSetLocation' -Value 1 -PropertyType DWord -Force
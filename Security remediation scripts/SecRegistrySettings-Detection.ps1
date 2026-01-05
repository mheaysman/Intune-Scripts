$regEntries = @(
    @{ #Require LDAP client signing to prevent tampering and protect directory authentication
        Path = "HKLM:\SYSTEM\CurrentControlSet\Services\ldap"
        Name = "LDAPClientIntegrity"
        Value = 2
        Type = "DWORD"
    },
    @{ #Encrypt LDAP client traffic to protect sensitive data in transit
        Path = "HKLM:\SYSTEM\CurrentControlSet\Services\ldap"
        Name = "LDAPClientConfidentiality"
        Value = 2
        Type = "DWORD"
    },
    @{ #Disable the local storage of passwords and credentials
        Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        Name = "DisableDomainCreds"
        Value = 1
        Type = "DWORD"
    },
    @{ #Disable 'Enumerate administrator accounts on elevation'
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI"
        Name = "EnumerateAdministrators"
        Value = 0
        Type = "DWORD"
    },
    @{ #Disable JavaScript on Adobe DC
        Path = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"
        Name = "bDisableJavaScript"
        Value = 1
        Type = "DWORD"
    },
    @{ #Enable 'Require domain users to elevate when setting a network's location'
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
        Name = "NC_StdDomainUserSetLocation"
        Value = 1
        Type = "DWORD"
    } 
)
Start-Transcript -Path "C:\Users\Public\Documents\Remediation-Scripts.log" -Append
Write-Output "Begin Detection Script SecRegistrySettings"
Write-Output "----------------------------------------------------------------"

foreach ($regEntry in $regEntries) {
    $check = (get-itemproperty -Path $regEntry.Path -Name $regEntry.Name -ErrorAction SilentlyContinue).($regEntry.Name)
    if ($check -ne $regEntry.Value){
        Write-Output "Remediation required for $($regEntry.Path) - $($regEntry.Name)"
        Exit 1 #remediation required
    }
    Write-Output "No remediation required for $($regEntry.Path) - $($regEntry.Name)"
    Write-Output "----------------------------------------------------------------"
}
Write-Output "No detections found. Remediation Script will not be run."
Stop-Transcript
exit 0 #remediation not required

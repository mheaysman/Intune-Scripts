

#Connect to Exchange Online
Connect-ExchangeOnline

#Block 3rd party storage providers in OWA
Set-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default -AdditionalStorageProvidersAvailable $false

#Enable mailbox auditing for new mailboxes
Set-OrganizationConfig -AuditDisabled $false

#Ensure auditing is enabled for all mailboxes
Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    if ($_.AuditEnabled -eq $false) {
        Write-Host "Enabling mailbox auditing for $($_.DisplayName)"
        Set-Mailbox -Identity $_.Identity -AuditEnabled $true
    } else {
        Write-Host "Mailbox auditing already enabled for $($_.DisplayName)"
    }
}

#enable mailtips
Set-OrganizationConfig -MailTipsAllTipsEnabled $true -MailTipsExternalRecipientsTipsEnabled $true -MailTipsGroupMetricsEnabled $true -MailTipsLargeAudienceThreshold '25'


















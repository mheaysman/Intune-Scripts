Import-Module ExchangeOnlineManagement
Import-Module Microsoft.Graph

#--------------------------------------------------------------------------------------
#Variables Section
#--------------------------------------------------------------------------------------
$targetUser = "first.lastname@domain.com"
$accessMailboxUser = "manager.lastname@domain.com"

#--------------------------------------------------------------------------------------
#Exchange Online Commands
#--------------------------------------------------------------------------------------
Connect-ExchangeOnline

#Remove from all distribution groups / mail-enabled security groups
Get-DistributionGroup | ForEach-Object {
    $group = $_
    $members = Get-DistributionGroupMember -Identity $group.Identity -ResultSize Unlimited
    foreach ($member in $members) {
        if ($member.PrimarySmtpAddress -eq $targetUser) {
            Write-Host "Removing $($member.PrimarySmtpAddress) from group $($group.Name)"
            Remove-DistributionGroupMember -Identity $group.Identity -Member $member.PrimarySmtpAddress -Confirm:$false
        }
    }
    Get-DistributionGroupMember -Identity $group.Identity -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -eq $targetUser } | Where-Object { $_.PrimarySmtpAddress -eq $targetUser } | Remove-DistributionGroupMember
}
#Convert mailbox to shared mailbox
Write-Host "Converting mailbox $($targetUser) to shared mailbox"
Set-Mailbox -Identity $targetUser -Type "Shared"
#give full access to the mailbox to another user
Write-Host "Granting full access to mailbox $($targetUser) for user $($accessMailboxUser)"
Add-MailboxPermission -Identity $targetUser -Trustee $accessMailboxUser -AccessRights Full
#give send as permission to another user
Write-Host "Granting SendAs permission for mailbox $($targetUser) to user $($accessMailboxUser)"
Add-RecipientPermission -Identity $targetUser -Trustee $accessMailboxUser -AccessRights SendAs

#--------------------------------------------------------------------------------------
#Graph Commands (Entra)
#--------------------------------------------------------------------------------------
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "LicenseAssignment.ReadWrite.All"
#get user by userPrincipalName
Write-Host "Searching for user $($targetUser)"
$MgUser = Get-MgUser -Filter “userPrincipalName eq '$($targetUser)'” -Top 1
Write-Host "User found: $($MgUser.DisplayName) with ID $($MgUser.Id)"
#Remove licenses from user
Write-Host "Removing licenses from user"
Get-MgUserLicenseDetail -UserId $MgUser.Id | ForEach-Object {
    $license = $_
    Write-Host "Removing license $($license.SkuId) from user"
    Remove-MgUserLicense -UserId $MgUser.Id -AddLicenses @() -RemoveLicenses @($license.SkuId)
}
#remove user from all groups
Write-Host "Removing user from all groups"
Get-MgUserMemberOf -UserId $MgUser.Id | ForEach-Object {
    $group = $_
        Write-Host "Removing user from group $($group.DisplayName)"
        Remove-MgGroupMember -GroupId $group.Id -UserId $MgUser.Id
}

#Block sign-in for user
Write-Host "Blocking sign-in for user"
Update-MgUser -UserId $MgUser.Id -AccountEnabled $false
#revoke all user sessions
Write-Host "Revoking all user sessions"
Revoke-MgUserAllRefreshToken -UserId $MgUser.Id
#hide user from global address list
Write-Host "Hiding user from address lists"
Update-MgUser -UserId $MgUser.Id -HideFromAddressListsEnabled $true

Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue

$Fix=Get-QADUser -Description "Account Created: 6/21/2012" | Select-Object FirstName,LastName,SamAccountName

FOREACH ($User in $Fix) {
    $FN=$User.FirstName
    $LN=$User.LastName
    $UserN=$User.SamAccountName
    $Name=$LN+" "+$FN
        Get-QadUser $UserN | Rename-QADObject -NewName $Name 
        }
    
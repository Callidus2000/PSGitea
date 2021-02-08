Write-PSFMessage "Connect4Testing" -Level Host
$Credentials = Get-PSFConfigValue "Gitea.pester.credentials" -ErrorAction Stop
$fqdn = Get-PSFConfigValue "Gitea.pester.fqdn" -ErrorAction Stop
$connection = Connect-Gitea -Url "$fqdn" -credentials $credentials

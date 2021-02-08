function Connect-Gitea {
	<#
	.SYNOPSIS
	Creates a new Connection Object to a Gitea Server instance.

	.DESCRIPTION
	Creates a new Connection Object to a Gitea Server instance.

	For connecting you always need the -Url as the function needs to know where the Server is located. As a
	minimum additional information you have to provide an authorization, either as -Credential or as -AccessToken.
	The usage of a credential object as the only information is *deprecated* and should be replaces in favor of
	an OAuth workflow. For OAuth you need to configure an application within the Web-UI. For more information
	see about_Gitea.

	.PARAMETER Credential
	Credential-Object for direct login.

	.PARAMETER Url
	The server root URL.

	.PARAMETER RefreshToken
	Neccessary for OAuth Login: Refresh-Token. Can be created with Request-OAuthRefreshToken.

	.PARAMETER AccessToken
	Neccessary for OAuth Login: Access-Token. Can be created with Request-OAuthRefreshToken.

	.PARAMETER AuthToken
	Neccessary for OAuth Login: Auth-Token. Can be created with Request-OAuthRefreshToken.

	.PARAMETER ClientID
	Neccessary for OAuth Login: The Id of the OAauth Client.

	.PARAMETER ClientSecret
	Neccessary for OAuth Login: The Secret of the OAauth Client.

	.PARAMETER EnableException
	Should Exceptions been thrown?

	.EXAMPLE
	$connection=Connect-Gitea -Url $url -ClientID $clientId -ClientSecret $clientSecret -Credential $cred
	Connect directly with OAuth and a Credential-Object


	.NOTES
	#>

	# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
	# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
	[CmdletBinding(DefaultParameterSetName = "AccessToken")]
	Param (
        [parameter(mandatory = $true, ParameterSetName = "BasicAuth")]
		[parameter(mandatory = $true, ParameterSetName = "AccessToken")]
        # [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("Gitea.url")]
        [string]$Url,
        [parameter(mandatory = $true, ParameterSetName = "BasicAuth")]
        [pscredential]$Credential,
		[parameter(mandatory = $true, ParameterSetName = "AccessToken")]
		[string]$AccessToken,
		[switch]$EnableException
	)

		Write-PSFMessage "ParameterSetName=$($PSCmdlet.ParameterSetName)"
		$serverRoot=Get-GiteaServerRoot -Url $Url
		Write-PSFMessage "Stelle Verbindung her zu $serverRoot" -Target $serverRoot
		if ($PSCmdlet.ParameterSetName -eq 'BasicAuth') {
			Write-PSFMessage "Basic Auth"
		$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"))
		$basicAuthValue = "Basic $encodedCreds"

		$Headers = @{
			Authorization = $basicAuthValue
			accept      = "application/json"
		}
			$result=Invoke-WebRequest -Uri "$serverRoot/api/v1/user" -Credential $Credential -Method Get -Headers $Headers
			Write-PSFMessage "result=$result"
			$result=Invoke-WebRequest -Uri "$serverRoot/api/v1/users/b10057231/tokens" -Credential $Credential -Method Get -Headers $Headers
			Write-PSFMessage "result=$result"
			# $connection = [Gitea]::new($Credential, $Url)
			# Invoke-PSFProtectedCommand -ActionString "Connect-Gitea.Connecting" -ActionStringValues $Url -Target $Url -ScriptBlock {
			# 	# $connection = [Gitea]::new($Credential.username, $Credential.GetNetworkCredential().password, $Url)
			# 	$connection = [Gitea]::new($Credential, $Url)
			# } -PSCmdlet $PSCmdlet  -EnableException $EnableException
		}
		# else{
		# 	if ($PSCmdlet.ParameterSetName -ne 'AccessToken') {
		# 		Write-PSFMessage "Aquiring AccessToken with splatting, ParameterSetName=$($PSCmdlet.ParameterSetName)"
		# 		$AccessToken=Request-GiteaOAuthToken @PSBoundParameters
		# 	}
		# 	$connection = [Gitea]::new($AccessToken,$Url)
		# }
		if (Test-PSFFunctionInterrupt) { return }
		Write-PSFMessage -string "Connect-Gitea.Connected"
		$connection
}
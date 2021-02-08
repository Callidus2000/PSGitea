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
	$connection = [GiteaConnection]::new()
	Write-PSFMessage "ParameterSetName=$($PSCmdlet.ParameterSetName)"
	$connection.serverRoot = Get-GiteaServerRoot -Url $Url
	$connection.WebServiceRoot = "$($connection.serverRoot)/api"
	# $connection.Headers.add("accept", "application/json")
	Write-PSFMessage "Stelle Verbindung her zu $($connection.serverRoot)" -Target $connection.serverRoot
	if ($PSCmdlet.ParameterSetName -eq 'BasicAuth') {
		Write-PSFMessage "Basic Auth"
		$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"))
		$connection.Headers.add("Authorization", "Basic $encodedCreds")

	}elseif ($PSCmdlet.ParameterSetName -eq 'AccessToken') {
		Write-PSFMessage "AccessToken"
		$connection.Headers.add("Authorization", "token $AccessToken")
	}
	Invoke-PSFProtectedCommand -Action "Connecting to Gitea" -Target $Url -ScriptBlock {
		$result=Get-GiteaCurrentAccount -Connection $Connection
		$connection.AuthenticatedUser = $result.login
	} -PSCmdlet $PSCmdlet  -EnableException $EnableException
	if (Test-PSFFunctionInterrupt) { return }
	Write-PSFMessage "Successfully connected with user $($connection.AuthenticatedUser)"
	$connection
}
function Remove-GiteaAccessToken {
    <#
    .SYNOPSIS
    Deletes an existing  access token. API-DELETE /v1/users/{username}/tokens/{token}

    .DESCRIPTION
    Deletes an existing  access token. API-DELETE /v1/users/{username}/tokens/{token}

    .PARAMETER Connection
    Connection Object

    .PARAMETER AccessToken
    Name/ID of the access token

    .PARAMETER UserName
    Name of the user for whom the token should get generated. If not set then the current user will be used

    .PARAMETER whatIf
    If enabled it does not execute the backend API call.

    .PARAMETER confirm
    If enabled the backend API Call has to be confirmed

    .EXAMPLE
    To be added

    in the Future

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory)]
        $Connection,
        [parameter(Mandatory)]
        [string]$AccessToken,
        [string]$UserName
    )
    if (!$UserName) {
        $UserName = $Connection.AuthenticatedUser
    }
    $apiCallParameter = @{
        Connection = $Connection
        method     = "Delete"
        Path       = "/v1/users/$Username/tokens/$AccessToken"
    }
    Invoke-PSFProtectedCommand -Action "Delete AccessToken $AccessToken for user $Username" -Target "$Name" -ScriptBlock {
        $result = Invoke-GiteaAPI @apiCallParameter
        Write-PSFMessage "AccessToken deleted"
        $result
    } -PSCmdlet $PSCmdlet
}
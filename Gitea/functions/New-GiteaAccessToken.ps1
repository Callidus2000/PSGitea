function New-GiteaAccessToken {
    <#
    .SYNOPSIS
    Creates a new access token. API-POST /v1/users/{username}/tokens

    .DESCRIPTION
    Creates a new access token. API-POST /v1/users/{username}/tokens

    .PARAMETER Connection
    Connection Object

    .PARAMETER Name
    Name for the new access token

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
        [string]$Name,
        [string]$UserName
    )
    if (!$UserName) {
        $UserName = $Connection.AuthenticatedUser
    }
    $apiCallParameter = @{
        Connection = $Connection
        method     = "Post"
        Path       = "/v1/users/$Username/tokens"
        Body       = @{
            name = $Name
        }
    }
    Invoke-PSFProtectedCommand -Action "Create AccessToken $Name for user $Username" -Target "$Name" -ScriptBlock {

        $result = Invoke-GiteaAPI @apiCallParameter
        Write-PSFMessage "AccessToken created"
        $result
    } -PSCmdlet $PSCmdlet
}
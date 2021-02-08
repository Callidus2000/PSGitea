function Get-GiteaCurrentAccount {
    <#
    .SYNOPSIS
    Retrieves all information regarding the current user’s account. API-GET /v1/user

    .DESCRIPTION
    Retrieves all information regarding the current user’s account. API-GET /v1/user

    .PARAMETER Connection
    Parameter description

    .EXAMPLE
    To be added
    in the Future

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory)]
        [GiteaConnection]$Connection
    )
    $apiCallParameter = @{
        Connection      = $Connection
        method          = "Get"
        Path            = "/v1/user"
        # EnableException = $true
    }

    Invoke-GiteaAPI @apiCallParameter
}
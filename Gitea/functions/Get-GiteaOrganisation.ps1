function Get-GiteaOrganisation {
    <#
    .SYNOPSIS
    Query all organisations.

    .DESCRIPTION
    Query all organisations.

    .PARAMETER Connection
    The connection to Gitea.

    .PARAMETER Limit
    How many entries should be returned?

    .PARAMETER Page
    Offset=Page*Limit

    .PARAMETER EnablePaging
    Should paging be handled automatically?

    .EXAMPLE
    Get-GiteaOrganisation -Connection $connection
    Returns all existing organisations

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory)]
        $Connection,
        $Limit=0,
        $Page=0,
        $EnablePaging=$true
    )
    $apiCallParameter = @{
        Connection      = $Connection
        method          = "Get"
        Path            = "/v1/orgs"
        UrlParameter=@{
        limit =$Limit
        page=$Page
    }
        EnablePaging = $EnablePaging
        # EnableException = $true
    }

    Invoke-GiteaAPI @apiCallParameter
}
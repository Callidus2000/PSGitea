function Invoke-GiteaAPI {
    <#
    .SYNOPSIS
    Generic API Call to the Dracoon API.

    .DESCRIPTION
    Generic API Call to the Dracoon API.

    .PARAMETER Connection
    Object of Class [Dracoon], stores the authentication Token and the API Base-URL

    .PARAMETER Path
    API Path to the REST function

    .PARAMETER Body
    Parameter for the API call; Converted to the POST body

    .PARAMETER UrlParameter
    Parameter for the API call; Converted to the GET URL parameter set

    .PARAMETER Method
    HTTP Method

    .PARAMETER ContentType
    HTTP-ContentType, defaults to "application/json;charset=UTF-8"

    .PARAMETER InFile
    File which should be transfered during the Request.

    .PARAMETER HideParameters
    If set to $true the password is hidden from logging

    .PARAMETER EnablePaging
    Wenn die API mit Paging arbeitet, kann über diesn Parameter ein automatisches Handling aktivieren.
    Dann werden alle Pages abgehandelt und nur die items zurückgeliefert.

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    $result = Invoke-DracoonAPI -connection $this -path "/v4/auth/login" -method POST -body @{login = $credentials.UserName; password = $credentials.GetNetworkCredential().Password; language = "1"; authType = "sql" } -hideparameters $true
    Login to the service

    .NOTES
    General notes
    #>

    param (
        [parameter(Mandatory)]
        $Connection,
        [parameter(Mandatory)]
        [string]$Path,
        [parameter(Mandatory)]
        [Microsoft.Powershell.Commands.WebRequestMethod]$Method,
        [Hashtable]$Body,
        [Hashtable]$UrlParameter,
        [bool]$HideParameters = $false,
        [string]$ContentType = "application/json;charset=UTF-8",
        [string]$InFile,
        [bool]$EnableException = $true,
        [bool]$EnablePaging = $false
    )
    $uri = $connection.webServiceRoot + $path
    if ($UrlParameter) {
        Write-PSFMessage "Converting UrlParameter to a Request-String and add it to the path"
        Write-PSFMessage "$($UrlParameter|ConvertTo-Json)"
        if ($UrlParameter.Contains("limit")) {
            If (($UrlParameter["page"] -lt 1) -and ($UrlParameter["limit"] -gt 0)) {
                $UrlParameter.page = 1
            }
        }
        $parameterString = (Get-EncodedParameterString($UrlParameter))
        $uri = $uri + '?' + $parameterString.trim("?")
    }
    $restAPIParameter = @{
        Uri         = $Uri
        method      = $Method
        body        = ($Body | Remove-NullFromHashtable -Json)
        Headers     = $connection.headers
        ContentType = $ContentType
    }
    If ($Body) {
        $restAPIParameter.body = ($Body | Remove-NullFromHashtable -Json)
    }
    If ($InFile) {
        $restAPIParameter.InFile = $InFile
    }
    Write-PSFMessage -Message "$(("$Method").ToUpper()) $uri" -Target $connection

    $tempBody = $body
    if ($hideParameters) {
        if ($tempBody.ContainsKey("password")) { $tempBody.set_Item("password", "*****") }
    }
    if ($tempBody) {
        Write-PSFMessage ("Invoking Uri {0} with {1} body" -f $uri, ($tempBody  | Remove-NullFromHashtable -Json))
    }
    else {
        Write-PSFMessage ("Invoking Uri {0}" -f $uri)
    }

    try {
        Write-PSFMessage -Level Debug "restAPIParameter= $($restAPIParameter|ConvertTo-Json -Depth 5)"
        $response = Invoke-WebRequest @restAPIParameter
        $result = $response.Content | ConvertFrom-Json
        Write-PSFMessage "Response-Header: $($response.Headers|Format-Table|Out-String)" -Level Debug
        Write-PSFMessage -Level Debug "result= $($result|ConvertTo-Json -Depth 5)"
        if ($EnablePaging -and (-not ($response.Headers["X-Total-Count"]))) {
            Write-PSFMessage "Paging enabled, but no X-Total-Count header" -Level Warning
        }
        elseif ($EnablePaging) {
            $totalCount = $response.Headers["X-Total-Count"]
            Write-PSFMessage "Paging enabled, starting loop, totalCount=$totalCount"
            $allItems = $result
            $resultCount = ($result | Measure-Object).count
            write-psfmessage "Current Item-Count: $(($allItems|Measure-Object).count)"
            # If no Page was given as a parameter then the returned object count as the configured limit
            if (!($UrlParameter.limit)) {
                $UrlParameter.limit = $resultCount
            }
            # If no Page was given as a parameter then it was page 1 we just requested
            if (!($UrlParameter.page)) {
                $UrlParameter.page = 1
            }

            while ($totalCount -gt $allItems.count) {
                # Fetch the next page of items
                $UrlParameter.page = $UrlParameter.page + 1
                Write-PSFMessage "totalCount=$totalCount -gt allItems.count=$($allItems.count)"
                $nextParameter = @{
                    Connection     = $Connection
                    Path           = $Path
                    Body           = $Body
                    UrlParameter   = $UrlParameter
                    Method         = $Method
                    HideParameters = $HideParameters
                    # NO EnablePaging in the next Call
                }
                write-psfmessage "InvokeAPI with Params= $($nextParameter|convertto-json -depth 10)" -Level Debug
                $result = Invoke-GiteaAPI @nextParameter
                $allItems += ($result)
            }
            return $allItems
        }
    }
    catch {
        $result = $_.errordetails
        Write-PSFMessage "$result" -Level Critical
        If ($EnableException) {
            throw $_#$result.Message
        }
        else {
            return
        }
    }
    return $result
}
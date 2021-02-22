Set-PSFScriptblock -Name 'Gitea.PagingHandler' -Scriptblock {
    # $EnablePaging -eq $true
    Write-PSFMessage "Gitea.PagingHandler"
    try {
        if (-not ($response.Headers["X-Total-Count"])) {
            Write-PSFMessage "Paging enabled, but no X-Total-Count header" -Level Warning
        }
        else {
            $totalCount = $response.Headers["X-Total-Count"]
            Write-PSFMessage "Paging enabled, starting loop, totalCount=$totalCount" -ModuleName Gitea -FunctionName 'Gitea-PagingHandler'
            $allItems = $result
            $resultCount = ($result | Measure-Object).count
            write-psfmessage "Current Item-Count: $(($allItems|Measure-Object).count)" -ModuleName Gitea -FunctionName 'Gitea-PagingHandler'
            Write-PSFMessage -Level Host -Message "InitialAllItems: $($allItems|ft|Out-String)"
            Write-PSFMessage -Level Host -Message "InitialAllItems: $($allItems.getType()|Out-String)"
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
                Write-PSFMessage "totalCount=$totalCount -gt allItems.count=$($allItems.count)"  -ModuleName Gitea -FunctionName 'Gitea-PagingHandler'
                $nextParameter = @{
                    Connection     = $Connection
                    Path           = $Path
                    Body           = $Body
                    UrlParameter   = $UrlParameter
                    Method         = $Method
                    HideParameters = $HideParameters
                    # NO EnablePaging in the next Call
                }
                write-psfmessage "InvokeAPI with Params= $($nextParameter|convertto-json -depth 10)" -Level Debug -ModuleName Gitea -FunctionName 'Gitea-PagingHandler'
                Write-PSFMessage -Level Host -Message "AllItems: $($allItems|ft|Out-String)"
                $result = Invoke-GiteaAPI @nextParameter
                Write-PSFMessage -Level Host -Message "Newresult: $($result|ft|Out-String)"
                Write-PSFMessage -Level Host -Message "allItems.count.before: $($allItems.count)"
                $allItems += ($result)
                Write-PSFMessage -Level Host -Message "allItems.count.after: $($allItems.count)"
            }

            Write-PSFMessage -Level Host -Message "Return allItems: $($allItems|ft|Out-String)"
            return $allItems
        }
    }
    catch {
        Write-PSFMessage "$_" -ErrorRecord $_ -Tag "Catch"
    }
}
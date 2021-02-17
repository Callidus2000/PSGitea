Describe  "Get-GiteaOrganisation Tests" {
    BeforeAll {
        . "$PSScriptRoot\Connect4Testing.ps1"
    }
    It "Query all organisations" {
        Get-GiteaOrganisation -Connection $connection | Should -Not -BeNullOrEmpty
    }
    It "Query all organisations, Test-Paging" {
        $allOrgs=Get-GiteaOrganisation -Connection $connection
        $allOrgsCount=$allOrgs.count
        $allOrgsCount | Should -BeGreaterThan 0
        if ($allOrgsCount -gt 1){
            $pageSize = [math]::Ceiling($allOrgsCount / 5)
            Write-PSFMessage "pageSize=$pageSize, allOrgsCount=$allOrgsCount"
            $pagingOrgs = Get-GiteaOrganisation -Connection $connection -Page 1 -Limit $pageSize
            $pagingOrgs.count | Should -Be $allOrgsCount
            $pagingOrgs = Get-GiteaOrganisation -Connection $connection -Limit $pageSize
            $pagingOrgs.count | Should -Be $allOrgsCount
            $pagingOrgs = Get-GiteaOrganisation -Connection $connection -Page 1 -Limit $pageSize -EnablePaging $false
            $pagingOrgs.count | Should -Be $pageSize
        }
    }
}
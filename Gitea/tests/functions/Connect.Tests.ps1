Describe  "Connection tests" {
    Describe "Test internal ServerRoot-Helper" {
        It "Check converting a given URL" {
            Get-GiteaServerRoot "my.server.de" | Should -Be "https://my.server.de"
            Get-GiteaServerRoot "my.server.de/" | Should -Be "https://my.server.de"
            Get-GiteaServerRoot "http://my.server.de" | Should -Be "https://my.server.de"
            Get-GiteaServerRoot "http://my.server.de/" | Should -Be "https://my.server.de"
        }
    }
    Context "OAuth registration available" {
        BeforeAll {
            $credentials = Get-PSFConfigValue "Gitea.pester.credentials" -ErrorAction Stop
            $fqdn = Get-PSFConfigValue "Gitea.pester.fqdn" -ErrorAction Stop
        }
        It "Anmeldung ohne OAuth, falsche Credentials" {
            $wrongCreds = new-object -typename System.Management.Automation.PSCredential -argumentlist "anonymous", (ConvertTo-SecureString "password" -AsPlainText -Force)
            $connection = Connect-Gitea -Url "$fqdn" -Credential $wrongCreds
            $connection | Should -BeNullOrEmpty
        }
        Context "Direct login with Connect-Gitea without explicit usage of Request-GiteaOAuthToken"{
            It "Connect with grant_type=password"{
                $connection=Connect-Gitea -url $fqdn -Credential $credentials
                $connection | Should -Not -BeNullOrEmpty
            }
        }
    #     Context "Create an Refresh Token and a Access Token based on it" {
    #         beforeall {
    #             $refreshToken = Request-GiteaOAuthToken -url $fqdn -ClientID $ClientID -clientSecret $clientSecret -Credential $credentials -TokenType "refresh"
    #             $accessToken = Request-GiteaOAuthToken -url $fqdn -ClientID $ClientID -clientSecret $clientSecret -RefreshToken $refreshToken
    #         }
    #         It "Access token gets generated from RefrehToken" {
    #             $refreshToken | Should -Match "\w{32}" -Because "RefreshToken is alphanumeric and 32 long"
    #             $accessToken | Should -Match "\w{32}" -Because "AccessToken is alphanumeric and 32 long"
    #             $accessToken | Should -not -Be $refreshToken -Because "AccessToken is different from RefreshToken"
    #         }
    #         It "Login with generated access token" {
    #             $accessToken | Should -Match "\w{32}" -Because "AccessToken is alphanumeric and 32 long"
    #             $connection=Connect-Gitea -Url "https://$fqdn" -AccessToken $accessToken
    #             $connection | Should -Not -BeNullOrEmpty
    #             Test-GiteaConnection -Connection $connection | Should -BeTrue
    #         }
    #         It "Login with refresh token" {
    #             $refreshToken | Should -Match "\w{32}" -Because "AccessToken is alphanumeric and 32 long"
    #             $connection = Connect-Gitea -Url "https://$fqdn" -RefreshToken $refreshToken -ClientID $ClientID -clientSecret $clientSecret
    #             $connection | Should -Not -BeNullOrEmpty
    #             Test-GiteaConnection -Connection $connection | Should -BeTrue
    #         }
    #         It "Connection not pingable" {
    #             $accessToken | Should -Match "\w{32}" -Because "AccessToken is alphanumeric and 32 long"
    #             $connection=Connect-Gitea -Url "https://$fqdn" -AccessToken $accessToken
    #             $connection.webServiceRoot="$($connection.webServiceRoot)/notAvailable"
    #             { Test-GiteaConnection -Connection $connection } | Should -Throw "API not pingable*"
    #         }
    #     }
    }
}
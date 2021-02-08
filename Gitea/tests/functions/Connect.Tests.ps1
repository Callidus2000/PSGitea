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
        Context "Direct login with Connect-Gitea"{
            It "Connect with Credentials"{
                $connection=Connect-Gitea -url $fqdn -Credential $credentials
                $connection | Should -Not -BeNullOrEmpty
            }
        }
        Context "Login with Connect-Gitea with newly created access token"{
            It "Connect with access token"{
                $connection=Connect-Gitea -url $fqdn -Credential $credentials
                $connection | Should -Not -BeNullOrEmpty
                $accessToken=New-GiteaAccessToken -Connection $connection -Name "pester"
                $secondConnection = Connect-Gitea -url $fqdn -AccessToken $accessToken.sha1
                $secondConnection | Should -Not -BeNullOrEmpty
                $secondConnection.AuthenticatedUser | Should -Be $connection.AuthenticatedUser
                Remove-GiteaAccessToken -Connection $connection -AccessToken pester
                $secondConnection = Connect-Gitea -url $fqdn -AccessToken $accessToken.sha1
                $secondConnection | Should -BeNullOrEmpty
            }
        }
   }
}
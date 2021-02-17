﻿<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPLv3 License][license-shield]][license-url]


<br />
<p align="center">
<!-- PROJECT LOGO
  <a href="https://github.com/Callidus2000/PSGitea">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
-->

  <h3 align="center">Gitea Powershell Module</h3>

  <p align="center">
    This Powershell Module is a wrapper for the API of <a href="https://gitea.io/">Gitea</a>
    <br />
    <a href="https://github.com/Callidus2000/PSGitea"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Callidus2000/PSGitea/issues">Report Bug</a>
    ·
    <a href="https://github.com/Callidus2000/PSGitea/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This Powershell Module is a wrapper for the API of Gitea. Gitea is a community managed lightweight code hosting solution written in Go which is published under the MIT license. Further information about Gitea can be found at https://gitea.io/.

The API is very well documented with swagger, documentation can either be found at https://try.gitea.io/api/swagger or (for your custom installation) at https://yourdomain.com/api/swagger.

**The current Status of this project is BETA**. I've cloned the necessary parts of my [Dracoon Project](https://github.com/Callidus2000/Dracoon) as both projects provide a wrapper functionality for an existing API. The few existing functions are only for testing the base function (`Invoke-GiteaAPI`). In the near future it may happen that I've got tasked with automation of our internal Gitea setup and if this happens I will add the needed code to this project. Until then please consider [contributing](#Contributing) to the project.

### Built With

* [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment)
* [psframework](https://github.com/PowershellFrameworkCollective/psframework)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

All prerequisites will be installed automatically.

### Installation

The releases are published in the Powershell Gallery, therefor it is quite simple:
  ```powershell
  Install-Module Gitea -Force -AllowClobber
  ```
The `AllowClobber` option is currently neccessary because of an issue in the current PowerShellGet module. Hopefully it will not be needed in the future any more.

<!-- USAGE EXAMPLES -->
## Usage

The module is a wrapper for the Gitea API. No special setup needed for getting started.

Now it's time to open the powershell. Prepare the basic variables:
```powershell
$fqnd="https://mygitea.mydomain.com/"
$cred=Get-Credential -Message "PSGitea"
$connection=Connect-PSGitea -Url $url -Credential $cred
```
As you now have a connection to your Gitea installation you can use it to interact with it.
```powershell
# Query the current user account
Get-GiteaCurrentAccount -Connection $connection

# Create a personal access token
$accessToken=New-GiteaAccessToken -Connection $connection -Name "pester"
# and connect with it
$secondConnection = Connect-Gitea -url $url -AccessToken $accessToken.sha1
# Delete the access token
Remove-GiteaAccessToken -Connection $connection -AccessToken pester
```

<!-- ROADMAP -->
## Roadmap
New features will be added if any of my scripts need it ;-)

See the [open issues](https://github.com/Callidus2000/PSGitea/issues) for a list of proposed features (and known issues).

If you need a special function feel free to contribute to the project.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**. For more details please take a look at the [CONTRIBUTE](docs/CONTRIBUTING.md#Contributing-to-this-repository) document

Short stop:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the GNU GENERAL PUBLIC LICENSE version 3. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact


Project Link: [https://github.com/Callidus2000/PSGitea](https://github.com/Callidus2000/PSGitea)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [Friedrich Weinmann](https://github.com/FriedrichWeinmann) for his marvelous [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and [psframework](https://github.com/PowershellFrameworkCollective/psframework)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Callidus2000/PSGitea.svg?style=for-the-badge
[contributors-url]: https://github.com/Callidus2000/PSGitea/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Callidus2000/PSGitea.svg?style=for-the-badge
[forks-url]: https://github.com/Callidus2000/PSGitea/network/members
[stars-shield]: https://img.shields.io/github/stars/Callidus2000/PSGitea.svg?style=for-the-badge
[stars-url]: https://github.com/Callidus2000/PSGitea/stargazers
[issues-shield]: https://img.shields.io/github/issues/Callidus2000/PSGitea.svg?style=for-the-badge
[issues-url]: https://github.com/Callidus2000/PSGitea/issues
[license-shield]: https://img.shields.io/github/license/Callidus2000/PSGitea.svg?style=for-the-badge
[license-url]: https://github.com/Callidus2000/PSGitea/blob/master/LICENSE


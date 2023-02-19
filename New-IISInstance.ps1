function New-IISInstance {
    <#
    You have been tasked with automating the process of deploying and configuring a web
    application in a secure manner. As part of this task, you need to create a PowerShell script
    that will:

    - Install and configure IIS (Internet Information Services) on a Windows Server machine
    - Create a new website in IIS with HTTPS binding and a self-signed SSL certificate
    - Download the latest version of the web application from a Git repository
    - Install the necessary dependencies for the web application
    - Configure the web application with the required settings and deploy it to the website in IIS
    - Set up the firewall rules to allow incoming traffic only on the necessary ports
    #>
}

Describe "New-IISInstance" {
    Context "Installing and Configuring IIS" {
        It "Should install and configure IIS without errors" {
            # Test if IIS is installed
            $iisInstalled = Get-WindowsFeature -Name Web-Server
            $iisInstalled.Installed.Should.Be($true)
    
            # Test if IIS service is running
            $iisService = Get-Service -Name W3SVC
            $iisService.Status.Should.Be("Running")
        }
    }
    
    Context "Creating a New Website with HTTPS Binding and a Self-signed SSL Certificate" {
        It "Should create a new website with HTTPS binding and a self-signed SSL certificate without errors" {
            # Test if the website is created
            $websiteExists = (Get-Website -Name "MyWebApp").Count -gt 0
            $websiteExists.Should.Be($true)
    
            # Test if the website has HTTPS binding
            $httpsBindingExists = (Get-WebBinding -Name "MyWebApp" -Protocol "https").Count -gt 0
            $httpsBindingExists.Should.Be($true)
    
            # Test if the SSL certificate is self-signed
            $certThumbprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*CN=MyWebApp*" }).Thumbprint
            $cert = Get-ChildItem -Path Cert:\LocalMachine\My\$certThumbprint
            $cert.Issuer.Should.Contain("CN=MyWebApp")
            $cert.Subject.Should.Contain("CN=MyWebApp")
            $cert.SignatureAlgorithm.FriendlyName.Should.Contain("sha256RSA")
            $cert.Extensions | Where-Object { $_.Oid.FriendlyName -eq "Basic Constraints" } | ForEach-Object { $_.Format(0) }.Should.Contain("Subject Type=End Entity")
        }
    }

    Context "Downloading the Latest Version of the Web Application" {
        It "Should download the latest version of the web application without errors" {
            # Test if the web application directory exists
            $webAppDirectoryExists = Test-Path -Path "C:\inetpub\wwwroot\MyWebApp"
            $webAppDirectoryExists.Should.Be($true)
    
            # Test if the web application files were downloaded
            $webAppFilesExist = (Get-ChildItem -Path "C:\inetpub\wwwroot\MyWebApp" -Recurse | Where-Object { $_.Extension -ne ".config" }).Count -gt 0
            $webAppFilesExist.Should.Be($true)
        }
    }
    
    Context "Installing the Necessary Dependencies" {
        It "Should install the necessary dependencies without errors" {
            # Test if the required dependencies are installed
            $dependenciesInstalled = (Get-Module -ListAvailable | Where-Object { $_.Name -eq "WebAdministration" }).Count -gt 0
            $dependenciesInstalled.Should.Be($true)
        }
    }

    Context "Configuring and Deploying the Web Application to the Website in IIS" {
        It "Should configure and deploy the web application to the website in IIS without errors" {
            $websiteDirectory = (Get-Website -Name "MyWebApp").PhysicalPath
            $webAppDeployed = (Get-ChildItem -Path $websiteDirectory -Recurse | Where-Object { $_.Extension -ne ".config" }).Count -gt 0
            $webAppDeployed.Should.Be($true) }
    }

    Context "Setting Up Firewall Rules" {
        It "Should configure firewall rules for the specified ports without errors" {
            # Test if the firewall rules are created
            $firewallRules = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "MyApp-*" }
            $firewallRules.Count.Should.Be(2)
    
            # Test if the firewall rules have the correct properties
            $firewallRules | ForEach-Object {
                $_.Enabled.Should.Be($true)
                $_.Direction.Should.Be("Inbound")
                $_.Protocol.Should.Be("TCP")
                $_.Action.Should.Be("Allow")
            }
    
            # Test if the firewall rules have the correct port numbers
            $httpPortRule = $firewallRules | Where-Object { $_.LocalPort -eq 80 }
            $httpsPortRule = $firewallRules | Where-Object { $_.LocalPort -eq 443 }
            $httpPortRule.Should.Not.Be($null)
            $httpsPortRule.Should.Not.Be($null)
        }
    }
    
}

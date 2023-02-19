Import-Module Pester

function New-SecurePassword {
    param (
        [Parameter()]
        [int] $Length = 16,

        [Parameter()]
        [bool] $WithLowercase = $true,

        [Parameter(Mandatory = $false)]
        [bool] $WithUppercase = $true,

        [Parameter(Mandatory = $false)]
        [bool] $WithNumber = $true,

        [Parameter(Mandatory = $false)]
        [bool] $WithSpecial = $true
    )

    if ($Length -le 16) {
        $Length = 16
    }

    $lowercase = "abcdefghijklmnopqrstuvwxyz"
    $uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $number = "0123456789"
    $special = "!@#$%&*"

    $characters = ""

    if ($WithLowercase) {
        $characters += $lowercase
    }

    if ($WithUppercase) {
        $characters += $uppercase
    }

    if ($WithNumber) {
        $characters += $number
    }

    if ($WithSpecial) {
        $characters += $special
    }

    if ($characters.Length -eq 0) {
        throw "You must have at least one character set enabled to continue."
    }

    $password = ""

    for ($i = 0; $i -lt $Length; $i++) {
        $index = Get-Random -Minimum 0 -Maximum $characters.Length
        $character = $characters[$index]
        $password += $character
    }

    return $password
}



Describe "New-SecurePassword" {
    Context "When no parameters are passed" {
        It "Should return a password of length 16" {
            $password = New-SecurePassword
            $password.Length | Should -Be 16
        }
    }

    Context "When length parameter smaller than 16 is passed" {
        It "Should return a password of specified length" {
            $password = New-SecurePassword -Length 10
            $password.Length | Should -Be 16
        }
    }

    Context "When length parameter bigger than 16 is passed" {
        It "Should return a password of specified length" {
            $password = New-SecurePassword -Length 24
            $password.Length | Should -Be 24
        }
    }

    Context "When only lowercase characters are enabled" {
        It "Should only return lowercase characters" {
            $password = New-SecurePassword -WithLowercase $true -WithUppercase $false -WithNumber $false -WithSpecial $false
            $password | Should -Match "[a-z]+"
        }
    }

    Context "When only uppercase characters are enabled" {
        It "Should only return uppercase characters" {
            $password = New-SecurePassword -WithLowercase $false -WithUppercase $true -WithNumber $false -WithSpecial $false
            $password | Should -Match "[A-Z]+"
        }
    }

    Context "When only number characters are enabled" {
        It "Should only return number characters" {
            $password = New-SecurePassword -WithLowercase $false -WithUppercase $false -WithNumber $true -WithSpecial $false
            $password | Should -Match "\d+"
        }
    }

    Context "When only special characters are enabled" {
        It "Should only return special characters" {
            $password = New-SecurePassword -WithLowercase $false -WithUppercase $false -WithNumber $false -WithSpecial $true
            $password | Should -Match "[!@#\$%&\*]+"
        }
    }

    Context "When all characters are enabled" {
        It "Should only return all types of characters" {
            $password = New-SecurePassword -WithLowercase $true -WithUppercase $true -WithNumber $true -WithSpecial $true
            $password | Should -Match "[a-zA-Z0-9!@#\$%&\*]+"
        }
    }

    Context "When no character sets are enabled" {
        It "Should throw an error" {
            { New-SecurePassword -WithLowercase $false -WithUppercase $false -WithNumber $false -WithSpecial $false } | Should -Throw
        }
    }
}

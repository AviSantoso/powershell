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
        Write-Error "You must have at least one character set enabled to continue."
        return 1
    }

    $password = ""

    for ($i = 0; $i -lt $Length; $i++) {
        $index = Get-Random -Minimum 0 -Maximum $characters.Length
        $character = $characters[$index]
        $password += $character
    }

    return $password
}
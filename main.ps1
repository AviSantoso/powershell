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

function Remove-FilesByExtension {
    <#SECTION - Remove-FilesByExtension
    Write a function named Remove-FilesByExtension that takes in two parameters: $Path and $Extension.
    - $Path should be the path to the directory where the files should be removed.
    - $Extension should be the extension of the files to be removed.
    - The function should recursively search through all directories and subdirectories in $Path and remove all files that have the specified $Extension.
    #>

    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Extension
    )

    if (!$Path -or $Path.Length -le 0) {
        Write-Error "Path is empty."
    }

    if (!(Test-Path $Path)) {
        Write-Error "Path does not exist."
    }

    if (!$Extension -or $Extension.Length -le 0) {
        Write-Error "Extension is empty."
    }

    $toRemove = Get-ChildItem $Path -Recurse -Include "*.$Extension"

    Write-Host "Found $($toRemove.Length) items to remove"
    Write-Host $toRemove

    foreach ($item in $toRemove) {
        Write-Host "Removing $item"
        Remove-Item $item
    }
}


function Test-FilesByExtension {
    #SECTION - Test for Remove-FilesByExtension
    Write-Host "Testing Remove-FilesByExtension"

    # Setup
    $files = $("./$testDir/a.txt", "./$testDir/b.csv", "./$testDir/c/d.txt", "./$testDir/c/e.txt", "./$testDir/c/f.csv")
    foreach ($file in $files) {
        New-Item -ItemType "File" -Path $file -Force
    }

    # Expected
    $expected = Get-ChildItem -Path $testDir | Select-Object -ExpandProperty Name | Where-Object { $_.EndsWith(".csv") }

    # Execute
    Remove-FilesByExtension -Extension "txt" -Path $testDir

    # Check
    $actual = Get-ChildItem -Path $directory | Select-Object -ExpandProperty Name

    $isEqual = Compare-Object $expected $actual -SyncWindow 0 -IncludeEqual | Where-Object { $_.SideIndicator -ne '==' }

    if ($isEqual) {
        Write-Host "Test Passed"
    }
    else {
        Write-Host "Expected [$($expected -join ", ")] but got [$($actual -join ", ")]"
    }

    foreach ($file in $files) {
        if (!(Test-Path $file)) {
            Continue
        }
        Remove-Item $file -Force
    }
}

$testDir = "TestFiles"

if (!(Test-Path $testDir)) {
    New-Item $testDir -Force -ItemType "Folder"
}

Test-FilesByExtension

if (Test-Path $testDir) {
    Remove-Item $testDir
}
function Remove-FilesByExtension {
    <#
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

}

Describe "Remove-FilesByExtension" {
    $testDir = "TestFiles"

    BeforeAll {
        if (!(Test-Path $testDir)) {
            New-Item $testDir -Force -ItemType "Folder"
        }
    }

    It "should remove files in a folder matching an extension recursively." {
        $files = $(
            "./$testDir/a.txt",
            "./$testDir/b.csv",
            "./$testDir/c/d.txt",
            "./$testDir/c/e.txt",
            "./$testDir/c/f.csv"
        )

        foreach ($file in $files) {
            New-Item -ItemType "File" -Path $file -Force
        }
    
        $expected = Get-ChildItem -Path $testDir | Select-Object -ExpandProperty Name | Where-Object { $_.EndsWith(".csv") }
    
        Remove-FilesByExtension -Extension "txt" -Path $testDir
    
        $actual = Get-ChildItem -Path $directory | Select-Object -ExpandProperty Name
    
        $actual | Should -Be $expected
    
        foreach ($file in $files) {
            if (!(Test-Path $file)) {
                Continue
            }
            Remove-Item $file -Force
        }
    }

    AfterAll {
        if (Test-Path $testDir) {
            Remove-Item $testDir -Force -Recurse
        }
    }
}
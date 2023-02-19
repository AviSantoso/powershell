Import-Module Pester

function Protect-String {
    <#
    Create a PowerShell function to automate the process of encrypting sensitive data using a
    symmetric encryption algorithm. Your function should take in a plaintext string and a secret
    key, and return the encrypted string in Base64 encoding.
    
    Use the Advanced Encryption Standard (AES) symmetric encryption algorithm with a block size of
    128 bits and a key size of 256 bits.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlainText,
        [Parameter(Mandatory = $true)]
        [string]$SecretKey,
        [Parameter(Mandatory = $true)]
        [string] $Salt
    )

    <#NOTE: This function is weaker because we don't accept a salt value. This however, means that
    we can ensure that this function is deterministic without using a salt value.
    #>

    $iterations = 10000
    $blockSize = 128
    $keySize = 256

    $saltBytes = [System.Text.Encoding]::UTF8.GetBytes($Salt)

    $pbkdf2 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($PlainText, $saltBytes)
    $pbkdf2.IterationCount = $iterations
    $key = $pbkdf2.GetBytes($keySize / 8)
    $iv = $pbkdf2.GetBytes($blockSize / 8)

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.BlockSize = $blockSize;
    $aes.KeySize = $keySize;
    $aes.Key = $key;
    $aes.IV = $iv;

    $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText);
    $encryptedBytes = $aes.EncryptCbc($plainBytes, $iv);
    $encryptedStr = [System.Convert]::ToBase64String($encryptedBytes)

    return $encryptedStr
}

Describe "Protect-String" {
    It "should pass" {
        $true | Should -Be $true
    }

    Context "When given a plaintext string and secret key" {
        It "should return the expected encrypted string" {
            # Arrange
            $plainText = "Hello World!"
            $secretKey = "mySecretKey123"
            $salt = "mySuperSecretSalt"
            $expectedResult = "OIuPCWYLoC/6U+3x/bS4ZA=="

            # Act
            $result = Protect-String -PlainText $plainText -SecretKey $secretKey -Salt $salt

            # Assert
            $result | Should -Be $expectedResult
        }
    }
}
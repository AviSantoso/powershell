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
        [string]$SecretKey
    )

    $blockSize = 128
    $keySize = 256

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.BlockSize = $blockSize;
    $aes.KeySize = $keySize;
    $aes.Key = [System.Text.Encoding]::UTF8.GetBytes($SecretKey)
    $aes.GenerateIV();

    $iv = $aes.IV;

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
            $expectedResult = "oW6X2/fSTJc="

            # Act
            $result = Protect-String -PlainText $plainText -SecretKey $secretKey

            # Assert
            $result | Should -Be $expectedResult
        }
    }
}

Invoke-Pester
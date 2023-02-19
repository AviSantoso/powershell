function Protect-String {
    <#
    As a Junior DevSecOps Engineer, you have been tasked with creating a PowerShell function to
    automate the process of encrypting sensitive data using a symmetric encryption algorithm. Your
    function should take in a plaintext string and a secret key, and return the encrypted string in
    Base64 encoding.
    
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

    $aes = [System.Security.Cryptography.Aes]::Create()

    $aes.BlockSize = 128;
    $aes.KeySize = 256;

    $aes.GenerateKey();
    $aes.GenerateIV();

    $iv = $aes.Key;

    $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText);
    
    $encryptedBytes = $aes.EncryptCbc($plainBytes, $iv);
    
    $encryptedStr = [System.Text.Encoding]::UTF8.GetString($encryptedBytes);

    return $encryptedStr
}
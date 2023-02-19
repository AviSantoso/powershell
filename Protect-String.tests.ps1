Import-Module ./Protect-String.ps1

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

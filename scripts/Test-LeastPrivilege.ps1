# Test-LeastPrivilege.ps1
# Validates that the Azure Automation managed identity
# cannot create or modify Key Vault secrets.

Disable-AzContextAutosave -Scope Process

# Authenticate using the Automation Account managed identity
Connect-AzAccount -Identity

Write-Output "Managed Identity authentication successful."

$VaultName = "kv-pam-lab-cw22"
$TestSecretName = "Unauthorized-Test-Secret"

try {

    $SecureValue = ConvertTo-SecureString `
        "LeastPrivilege-Test-Value" `
        -AsPlainText `
        -Force

    # This operation is expected to fail because the managed
    # identity only has Key Vault Secrets User permissions.

    Set-AzKeyVaultSecret `
        -VaultName $VaultName `
        -Name $TestSecretName `
        -SecretValue $SecureValue `
        -ErrorAction Stop

    Write-Output "WARNING: Managed Identity was able to create a secret."

}
catch {

    Write-Output "EXPECTED DENIAL"
    Write-Output "Managed Identity cannot create or modify Key Vault secrets."
    Write-Output "Least-privilege control verified."
    Write-Output "Error: $($_.Exception.Message)"

}

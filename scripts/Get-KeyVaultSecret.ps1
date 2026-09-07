# Get-KeyVaultSecret.ps1
# Demonstrates secure Azure Key Vault secret retrieval
# using an Azure Automation managed identity.

Disable-AzContextAutosave -Scope Process

# Authenticate using the Automation Account managed identity
Connect-AzAccount -Identity

Write-Output "Managed Identity authentication successful."

$VaultName = "kv-pam-lab-cw22"
$SecretName = "Database-Password"

try {

    # Retrieve the secret from Azure Key Vault
    $Secret = Get-AzKeyVaultSecret `
        -VaultName $VaultName `
        -Name $SecretName `
        -ErrorAction Stop

    Write-Output "Secret retrieval successful."
    Write-Output "Secret Name: $SecretName"

    # Do NOT print the secret value
    Write-Output "Secret value was retrieved securely and was not written to logs."

}
catch {

    Write-Output "Secret retrieval failed."
    Write-Output "Error: $($_.Exception.Message)"

}

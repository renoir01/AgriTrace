# Import remaining Azure resources into Terraform state
# Resource Group and Container Registry are already imported
# Run this script from the infrastructure/azure directory

Write-Host "Starting import of remaining Azure resources..." -ForegroundColor Green

# Private DNS Zone
Write-Host "Importing Private DNS Zone..." -ForegroundColor Yellow
terraform import azurerm_private_dns_zone.postgresql "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com"

# Key Vault
Write-Host "Importing Key Vault..." -ForegroundColor Yellow
terraform import azurerm_key_vault.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.KeyVault/vaults/agritrace-dev-kv"

# Virtual Network
Write-Host "Importing Virtual Network..." -ForegroundColor Yellow
terraform import azurerm_virtual_network.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet"

# Network Security Group - App
Write-Host "Importing App Network Security Group..." -ForegroundColor Yellow
terraform import azurerm_network_security_group.app "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/networkSecurityGroups/agritrace-dev-app-nsg"

# Network Security Group - DB
Write-Host "Importing DB Network Security Group..." -ForegroundColor Yellow
terraform import azurerm_network_security_group.db "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/networkSecurityGroups/agritrace-dev-db-nsg"

# Public IP
Write-Host "Importing Public IP..." -ForegroundColor Yellow
terraform import azurerm_public_ip.app_gateway "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/publicIPAddresses/agritrace-dev-appgw-pip"

Write-Host "Import completed! Verifying imported resources..." -ForegroundColor Green
terraform state list

Write-Host "You can now run 'terraform plan' to see what changes need to be made." -ForegroundColor Green

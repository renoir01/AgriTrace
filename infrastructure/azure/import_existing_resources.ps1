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

# Subnets
Write-Host "Importing App Gateway Subnet..." -ForegroundColor Yellow
terraform import azurerm_subnet.app_gateway "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-appgw-subnet"

Write-Host "Importing Public Subnet..." -ForegroundColor Yellow
terraform import azurerm_subnet.public "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-public-subnet"

Write-Host "Importing Private Subnet..." -ForegroundColor Yellow
terraform import azurerm_subnet.private "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-private-subnet"

Write-Host "Importing Database Subnet..." -ForegroundColor Yellow
terraform import azurerm_subnet.database "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-db-subnet"

# Key Vault Secrets
Write-Host "Importing ACR Username Secret..." -ForegroundColor Yellow
terraform import azurerm_key_vault_secret.acr_username "https://agritrace-dev-kv.vault.azure.net/secrets/acr-username/b68a3dd786364a1a99e076e9cb1b5445"

Write-Host "Importing ACR Password Secret..." -ForegroundColor Yellow
terraform import azurerm_key_vault_secret.acr_password "https://agritrace-dev-kv.vault.azure.net/secrets/acr-password/2d4ab0d94d2b4c5db127e2d2c2a6721b"

Write-Host "Importing DB Password Secret..." -ForegroundColor Yellow
terraform import azurerm_key_vault_secret.db_password "https://agritrace-dev-kv.vault.azure.net/secrets/db-password/413331a4d3494a8d90ed6b65d6752375"

# Private DNS Zone Virtual Network Link
Write-Host "Importing Private DNS Zone Virtual Network Link..." -ForegroundColor Yellow
terraform import azurerm_private_dns_zone_virtual_network_link.postgresql "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com/virtualNetworkLinks/agritrace-dev-psql-dns-link"

Write-Host "Import completed! Verifying imported resources..." -ForegroundColor Green
terraform state list

Write-Host "You can now run 'terraform plan' to see what changes need to be made." -ForegroundColor Green

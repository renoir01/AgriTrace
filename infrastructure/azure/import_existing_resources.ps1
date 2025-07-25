# Import all Azure resources into Terraform state
# Run this script from the infrastructure/azure directory
# Includes all resources that need to be imported

Write-Host "Starting import of all Azure resources..." -ForegroundColor Green

# Resource Group
Write-Host "Importing Resource Group..." -ForegroundColor Yellow
terraform import azurerm_resource_group.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg"

# Container Registry
Write-Host "Importing Container Registry..." -ForegroundColor Yellow
terraform import azurerm_container_registry.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.ContainerRegistry/registries/agritracedevacr"

# Virtual Network
Write-Host "Importing Virtual Network..." -ForegroundColor Yellow
terraform import azurerm_virtual_network.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet"

# Subnets
Write-Host "Importing Subnets..." -ForegroundColor Yellow
terraform import azurerm_subnet.public "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-public-subnet"
terraform import azurerm_subnet.private "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-private-subnet"
terraform import azurerm_subnet.database "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-db-subnet"
terraform import azurerm_subnet.app_gateway "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-appgw-subnet"

# Network Security Groups
Write-Host "Importing Network Security Groups..." -ForegroundColor Yellow
terraform import azurerm_network_security_group.app "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/networkSecurityGroups/agritrace-dev-app-nsg"
terraform import azurerm_network_security_group.db "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/networkSecurityGroups/agritrace-dev-db-nsg"

# NSG Associations
Write-Host "Importing NSG Associations..." -ForegroundColor Yellow
terraform import azurerm_subnet_network_security_group_association.public "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-public-subnet"
terraform import azurerm_subnet_network_security_group_association.private "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet/subnets/agritrace-dev-private-subnet"

# Public IP
Write-Host "Importing Public IP..." -ForegroundColor Yellow
terraform import azurerm_public_ip.app_gateway "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/publicIPAddresses/agritrace-dev-appgw-pip"

# Key Vault
Write-Host "Importing Key Vault..." -ForegroundColor Yellow
terraform import azurerm_key_vault.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.KeyVault/vaults/agritrace-dev-kv"

# Key Vault Secrets
Write-Host "Importing Key Vault Secrets..." -ForegroundColor Yellow
terraform import azurerm_key_vault_secret.db_password "https://agritrace-dev-kv.vault.azure.net/secrets/db-password/3c19d015f84544c8badda209e784e8ad"
terraform import azurerm_key_vault_secret.acr_username "https://agritrace-dev-kv.vault.azure.net/secrets/acr-username/b68a3dd786364a1a99e076e9cb1b5445"
terraform import azurerm_key_vault_secret.acr_password "https://agritrace-dev-kv.vault.azure.net/secrets/acr-password/2d4ab0d94d2b4c5db127e2d2c2a6721b"
terraform import azurerm_key_vault_secret.db_connection_string "https://agritrace-dev-kv.vault.azure.net/secrets/db-connection-string/f73d96b505b44d04b82fc15f965c744d"

# Private DNS Zone
Write-Host "Importing Private DNS Zone..." -ForegroundColor Yellow
terraform import azurerm_private_dns_zone.postgresql "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com"

# Private DNS Zone VNet Link
Write-Host "Importing Private DNS Zone VNet Link..." -ForegroundColor Yellow
terraform import azurerm_private_dns_zone_virtual_network_link.postgresql "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com/virtualNetworkLinks/agritrace-dev-psql-dns-link"

# PostgreSQL Flexible Server
Write-Host "Importing PostgreSQL Flexible Server..." -ForegroundColor Yellow
terraform import azurerm_postgresql_flexible_server.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/agritrace-dev-psql-server"

# PostgreSQL Flexible Server Database
Write-Host "Importing PostgreSQL Database..." -ForegroundColor Yellow
terraform import azurerm_postgresql_flexible_server_database.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/agritrace-dev-psql-server/databases/agritrace"

# Container Groups
Write-Host "Importing Container Groups..." -ForegroundColor Yellow
terraform import azurerm_container_group.frontend "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.ContainerInstance/containerGroups/agritrace-dev-frontend-ci"
terraform import azurerm_container_group.backend "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.ContainerInstance/containerGroups/agritrace-dev-backend-ci"

# Application Gateway
Write-Host "Importing Application Gateway..." -ForegroundColor Yellow
terraform import azurerm_application_gateway.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/applicationGateways/agritrace-dev-appgw"

Write-Host "Import completed! Verifying imported resources..." -ForegroundColor Green
terraform state list

Write-Host "You can now run 'terraform plan' to see what changes need to be made." -ForegroundColor Green

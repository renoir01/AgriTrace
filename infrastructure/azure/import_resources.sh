#!/bin/bash

# Import existing Azure resources into Terraform state
echo "Starting import of existing Azure resources..."

# Container Registry
echo "Importing Container Registry..."
terraform import azurerm_container_registry.main /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.ContainerRegistry/registries/agritracedevacr

# Private DNS Zone
echo "Importing Private DNS Zone..."
terraform import azurerm_private_dns_zone.postgresql /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com

# Key Vault
echo "Importing Key Vault..."
terraform import azurerm_key_vault.main /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.KeyVault/vaults/agritrace-dev-kv

# Virtual Network
echo "Importing Virtual Network..."
terraform import azurerm_virtual_network.main /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/virtualNetworks/agritrace-dev-vnet

# Network Security Group - App
echo "Importing App Network Security Group..."
terraform import azurerm_network_security_group.app /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/networkSecurityGroups/agritrace-dev-app-nsg

# Network Security Group - DB
echo "Importing DB Network Security Group..."
terraform import azurerm_network_security_group.db /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/networkSecurityGroups/agritrace-dev-db-nsg

# Public IP
echo "Importing Public IP..."
terraform import azurerm_public_ip.app_gateway /subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/publicIPAddresses/agritrace-dev-appgw-pip

echo "Import completed! Verifying imported resources..."
terraform state list

echo "You can now run 'terraform plan' to see what changes need to be made."

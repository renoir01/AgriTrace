# Import final remaining Azure resources into Terraform state
# Run this script from the infrastructure/azure directory
# Only includes resources that still need to be imported

Write-Host "Starting import of final remaining Azure resources..." -ForegroundColor Green

# Backend Container Group
Write-Host "Importing Backend Container Group..." -ForegroundColor Yellow
terraform import azurerm_container_group.backend "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.ContainerInstance/containerGroups/agritrace-dev-backend-ci"

# PostgreSQL Flexible Server Database
Write-Host "Importing PostgreSQL Database..." -ForegroundColor Yellow
terraform import azurerm_postgresql_flexible_server_database.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/agritrace-dev-psql-server/databases/agritrace"

# Database Connection String Secret
Write-Host "Importing DB Connection String Secret..." -ForegroundColor Yellow
terraform import azurerm_key_vault_secret.db_connection_string "https://agritrace-dev-kv.vault.azure.net/secrets/db-connection-string/a42803e4dbca4b0f8c7e68c34f89d862"

# Application Gateway
Write-Host "Importing Application Gateway..." -ForegroundColor Yellow
terraform import azurerm_application_gateway.main "/subscriptions/ef573996-fc64-430c-88d1-a5da1fc15677/resourceGroups/agritrace-dev-rg/providers/Microsoft.Network/applicationGateways/agritrace-dev-appgw"

Write-Host "Import completed! Verifying imported resources..." -ForegroundColor Green
terraform state list

Write-Host "You can now run 'terraform plan' to see what changes need to be made." -ForegroundColor Green

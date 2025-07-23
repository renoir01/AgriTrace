# Azure Terraform Variables for AgriTrace Deployment
azure_location = "East US"
environment = "dev"
project_name = "agritrace"

# Networking Configuration
vnet_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

# Database Configuration
db_sku_name = "B_Standard_B1ms"
db_storage_mb = 32768
db_backup_retention_days = 7
db_geo_redundant_backup_enabled = false

# Container Configuration
container_cpu = 1
container_memory = 2

# Application Configuration
app_port = 8000
frontend_port = 3000

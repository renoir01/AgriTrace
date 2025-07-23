# Azure Database Infrastructure for AgriTrace

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "${var.project_name}-${var.environment}-psql-server"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  administrator_login    = var.db_admin_username
  administrator_password = random_password.db_password.result

  sku_name                     = var.db_sku_name
  version                      = "13"
  storage_mb                   = var.db_storage_mb
  backup_retention_days        = var.db_backup_retention_days
  geo_redundant_backup_enabled = var.db_geo_redundant_backup_enabled
  auto_grow_enabled            = true
  public_network_access_enabled = false

  delegated_subnet_id = azurerm_subnet.database.id
  private_dns_zone_id = azurerm_private_dns_zone.postgresql.id

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql]

  tags = local.common_tags
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "agritrace"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Private Endpoint for PostgreSQL
resource "azurerm_private_endpoint" "postgresql" {
  name                = "${local.name_prefix}-psql-pe"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.database.id

  private_service_connection {
    name                           = "${local.name_prefix}-psql-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.main.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  tags = local.common_tags
}

# Private DNS Zone for PostgreSQL
resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "${local.name_prefix}-psql-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.main.id
  tags                  = local.common_tags
}

# DNS A Record for Private Endpoint
resource "azurerm_private_dns_a_record" "postgresql" {
  name                = azurerm_postgresql_flexible_server.main.name
  zone_name           = azurerm_private_dns_zone.postgresql.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.postgresql.private_service_connection.0.private_ip_address]
  tags                = local.common_tags
}

# Key Vault for storing secrets
resource "azurerm_key_vault" "main" {
  name                = "${local.name_prefix}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  tags = local.common_tags
}

# Store database password in Key Vault
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.common_tags
}

# Store database connection string in Key Vault
resource "azurerm_key_vault_secret" "db_connection_string" {
  name  = "db-connection-string"
  value = "postgresql://${var.db_admin_username}:${random_password.db_password.result}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/agritrace?sslmode=require"
  key_vault_id = azurerm_key_vault.main.id
  tags         = local.common_tags
}

# Data source for current Azure client configuration
data "azurerm_client_config" "current" {}

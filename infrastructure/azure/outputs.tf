# Outputs for AgriTrace Azure Infrastructure

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = azurerm_subnet.private.id
}

output "database_server_name" {
  description = "Name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "database_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
  sensitive   = true
}

output "database_connection_string" {
  description = "PostgreSQL connection string"
  value       = azurerm_key_vault_secret.db_connection_string.value
  sensitive   = true
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}

output "container_registry_login_server" {
  description = "Login server URL for the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_admin_username" {
  description = "Admin username for the container registry"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "Admin password for the container registry"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}

output "backend_container_ip" {
  description = "Private IP address of the backend container"
  value       = azurerm_container_group.backend.ip_address
}

output "frontend_container_ip" {
  description = "Private IP address of the frontend container"
  value       = azurerm_container_group.frontend.ip_address
}

output "application_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.app_gateway.ip_address
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${azurerm_public_ip.app_gateway.ip_address}"
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "azure_location" {
  description = "Azure location/region"
  value       = var.azure_location
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

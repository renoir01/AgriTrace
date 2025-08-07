# Outputs for Networking Module
# These outputs can be referenced by other modules or root configuration

# Virtual Network Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

# Subnet Outputs
output "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.appgw.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = azurerm_subnet.private.id
}

output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database.id
}

# Network Security Group Outputs
output "appgw_nsg_id" {
  description = "ID of the Application Gateway NSG"
  value       = azurerm_network_security_group.appgw.id
}

output "app_nsg_id" {
  description = "ID of the application NSG"
  value       = azurerm_network_security_group.app.id
}

output "database_nsg_id" {
  description = "ID of the database NSG"
  value       = azurerm_network_security_group.database.id
}

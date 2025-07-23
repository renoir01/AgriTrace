# Azure Networking Infrastructure for AgriTrace

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.name_prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Public Subnet
resource "azurerm_subnet" "public" {
  name                 = "${local.name_prefix}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}

# Private Subnet for Containers
resource "azurerm_subnet" "private" {
  name                 = "${local.name_prefix}-private-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidr]
  
  # Delegate subnet to Container Instances
  delegation {
    name = "container-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Database Subnet for PostgreSQL Flexible Server
resource "azurerm_subnet" "database" {
  name                 = "${local.name_prefix}-db-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
  
  # Delegate subnet to PostgreSQL Flexible Server
  delegation {
    name = "postgresql-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Network Security Group for Application
resource "azurerm_network_security_group" "app" {
  name                = "${local.name_prefix}-app-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  # Allow HTTP traffic
  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS traffic
  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow application port
  security_rule {
    name                       = "AppPort"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = tostring(var.app_port)
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Database
resource "azurerm_network_security_group" "db" {
  name                = "${local.name_prefix}-db-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  # Allow PostgreSQL traffic from VNet
  security_rule {
    name                       = "PostgreSQL"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

# Associate NSG with public subnet
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# Associate NSG with private subnet
resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.db.id
}

# Public IP for Application Gateway
resource "azurerm_public_ip" "app_gateway" {
  name                = "${local.name_prefix}-appgw-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

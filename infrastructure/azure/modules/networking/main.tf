# Networking Module for AgriTrace
# This module creates all networking components including VNet, subnets, NSGs, and routing
# Designed for security with proper subnet segmentation and network security groups

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Virtual Network - Main network container for all resources
resource "azurerm_virtual_network" "main" {
  name                = "${var.name_prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Enable DDoS protection for production environments
  dynamic "ddos_protection_plan" {
    for_each = var.environment == "prod" ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}

# Application Gateway Subnet - Dedicated subnet for load balancer
resource "azurerm_subnet" "appgw" {
  name                 = "${var.name_prefix}-appgw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.appgw_subnet_cidr]
}

# Public Subnet - For resources that need internet access
resource "azurerm_subnet" "public" {
  name                 = "${var.name_prefix}-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}

# Private Subnet - For application containers (secure)
resource "azurerm_subnet" "private" {
  name                 = "${var.name_prefix}-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidr]

  # Delegate subnet to container instances for private networking
  delegation {
    name = "container-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Database Subnet - Isolated subnet for PostgreSQL
resource "azurerm_subnet" "database" {
  name                 = "${var.name_prefix}-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.db_subnet_cidr]

  # Delegate subnet to PostgreSQL flexible server
  delegation {
    name = "postgresql-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Network Security Group for Application Gateway
resource "azurerm_network_security_group" "appgw" {
  name                = "${var.name_prefix}-appgw-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow HTTP traffic
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1000
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
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow Application Gateway management traffic
  security_rule {
    name                       = "AllowGatewayManager"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Private Subnet (Application Containers)
resource "azurerm_network_security_group" "app" {
  name                = "${var.name_prefix}-app-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow traffic from Application Gateway
  security_rule {
    name                       = "AllowAppGateway"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000"
    source_address_prefix      = var.appgw_subnet_cidr
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Database Subnet
resource "azurerm_network_security_group" "database" {
  name                = "${var.name_prefix}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow PostgreSQL traffic from private subnet only
  security_rule {
    name                       = "AllowPostgreSQL"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = var.private_subnet_cidr
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "appgw" {
  subnet_id                 = azurerm_subnet.appgw.id
  network_security_group_id = azurerm_network_security_group.appgw.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

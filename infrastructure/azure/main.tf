# AgriTrace Azure Infrastructure as Code
# This Terraform configuration provisions all necessary Azure resources for AgriTrace

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Local values for resource naming and configuration
# These locals provide consistent naming and tagging across all resources
locals {
  # Resource naming convention: {project}-{environment}-{resource}
  name_prefix = "${var.project_name}-${var.environment}"
  location    = var.azure_location
  
  # Common tags applied to all resources for governance and cost tracking
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
    Owner       = "AgriTrace-Team"
    CostCenter  = "Agriculture-Tech"
  }
  
  # Network configuration derived from variables
  network_config = {
    vnet_cidr           = var.vnet_cidr
    public_subnet_cidr  = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    db_subnet_cidr      = var.db_subnet_cidr
    appgw_subnet_cidr   = var.appgw_subnet_cidr
  }
  
  # Container configuration for consistent resource allocation
  container_config = {
    cpu_cores      = var.container_cpu
    memory_gb      = var.container_memory
    restart_policy = var.container_restart_policy
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = local.location
  tags     = local.common_tags
}

# Random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

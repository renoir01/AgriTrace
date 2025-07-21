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

# Local values for resource naming
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  location    = var.azure_location
  
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
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

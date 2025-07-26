# Variables for AgriTrace Azure Infrastructure
# This file defines all configurable parameters for the infrastructure deployment

variable "azure_location" {
  description = "Azure region where all resources will be deployed"
  type        = string
  default     = "East US"
  
  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US", "West Central US",
      "Canada Central", "Canada East", "Brazil South", "UK South", "UK West",
      "West Europe", "North Europe", "France Central", "Germany West Central",
      "Switzerland North", "Norway East", "Sweden Central"
    ], var.azure_location)
    error_message = "Azure location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name for resource tagging and naming (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project used for resource naming and tagging"
  type        = string
  default     = "agritrace"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "Project name must be 3-20 characters, lowercase letters, numbers, and hyphens only."
  }
}

variable "vnet_cidr" {
  description = "CIDR block for Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_sku_name" {
  description = "PostgreSQL SKU name"
  type        = string
  default     = "B_Gen5_1"
}

variable "db_storage_mb" {
  description = "PostgreSQL storage in MB"
  type        = number
  default     = 20480
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "agritrace"
}

variable "db_admin_username" {
  description = "Database administrator username"
  type        = string
  default     = "agritrace_admin"
}

variable "container_cpu" {
  description = "CPU cores for container instances"
  type        = number
  default     = 1
}

variable "container_memory" {
  description = "Memory allocation for containers in GB"
  type        = number
  default     = 1.5
  
  validation {
    condition     = var.container_memory >= 0.5 && var.container_memory <= 16
    error_message = "Container memory must be between 0.5 and 16 GB."
  }
}

variable "django_settings_module" {
  description = "Django settings module to use"
  type        = string
  default     = "agritrace_project.settings"
}

variable "django_debug" {
  description = "Enable Django debug mode (should be false in production)"
  type        = bool
  default     = false
}

variable "container_restart_policy" {
  description = "Restart policy for containers"
  type        = string
  default     = "Always"
  
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.container_restart_policy)
    error_message = "Container restart policy must be one of: Always, Never, OnFailure."
  }
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/api/v1/health/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
  
  validation {
    condition     = var.health_check_interval >= 10 && var.health_check_interval <= 300
    error_message = "Health check interval must be between 10 and 300 seconds."
  }
}

variable "app_port" {
  description = "Port for the application"
  type        = number
  default     = 8000
}

variable "frontend_port" {
  description = "Port for the frontend application"
  type        = number
  default     = 3000
}

variable "db_backup_retention_days" {
  description = "Number of days to retain database backups"
  type        = number
  default     = 7
}

variable "db_geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup for database"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Custom domain name (optional)"
  type        = string
  default     = ""
}

variable "ssl_certificate_path" {
  description = "Path to SSL certificate (optional)"
  type        = string
  default     = ""
}

# Variables for AgriTrace Azure Infrastructure

variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "agritrace"
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

variable "db_username" {
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
  description = "Memory in GB for container instances"
  type        = number
  default     = 2
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

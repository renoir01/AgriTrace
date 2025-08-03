# Azure Container Instances for AgriTrace
# This file defines container groups for running the AgriTrace application components
# Uses public networking for accessibility and demonstration purposes

# Container Group for Backend Django Application
# Public container instance for demonstration and assessment purposes
resource "azurerm_container_group" "backend" {
  name                = "${local.name_prefix}-backend-ci"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"  # Public IP for accessibility
  dns_name_label      = "${local.name_prefix}-api" # DNS label for public FQDN
  os_type             = "Linux"
  restart_policy      = var.container_restart_policy

  container {
    name   = "backend"
    image  = "${azurerm_container_registry.main.login_server}/agritrace-backend:latest"
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = var.app_port
      protocol = "TCP"
    }

    # Environment variables for Django application configuration
    # These are non-sensitive configuration values
    environment_variables = {
      DJANGO_SETTINGS_MODULE = "agritrace_project.settings"  # Correct Django settings path
      DB_HOST               = azurerm_postgresql_flexible_server.main.fqdn
      DB_PORT               = "5432"  # PostgreSQL default port
      DB_NAME               = var.db_name
      DB_USER               = var.db_admin_username
      # Allow access from public endpoints, localhost, and private networks
      ALLOWED_HOSTS         = "${local.name_prefix}-api.${var.location}.azurecontainer.io,${local.name_prefix}.${var.location}.azurecontainer.io,localhost,127.0.0.1,*"
      DEBUG                 = tostring(var.django_debug)
      PORT                  = tostring(var.app_port)
      # Additional Django configuration
      PYTHONPATH            = "/app"
      PYTHONUNBUFFERED      = "1"
    }

    secure_environment_variables = {
      DB_PASSWORD = random_password.db_password.result
      SECRET_KEY  = random_password.django_secret.result
    }

    # Use the Docker entrypoint script for proper initialization
    # The entrypoint.sh script handles migrations, static files, and starts gunicorn
    # No commands override needed - let Docker use the defined ENTRYPOINT and CMD

    # Health check configuration for container monitoring
    # Ensures the Django application is responding correctly
    liveness_probe {
      http_get {
        path   = var.health_check_path
        port   = var.app_port
        scheme = "Http"
      }
      initial_delay_seconds = var.health_check_interval
      period_seconds        = var.health_check_interval
      timeout_seconds       = 10
      failure_threshold     = 3
    }

    readiness_probe {
      http_get {
        path   = var.health_check_path
        port   = var.app_port
        scheme = "Http"
      }
      initial_delay_seconds = 30
      period_seconds        = 10
      timeout_seconds       = 5
      failure_threshold     = 3
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.main.login_server
    username = azurerm_container_registry.main.admin_username
    password = azurerm_container_registry.main.admin_password
  }

  tags = local.common_tags
}

# Container Group for Frontend
resource "azurerm_container_group" "frontend" {
  name                = "${local.name_prefix}-frontend-ci"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "${local.name_prefix}" # DNS label for public FQDN
  os_type             = "Linux"
  restart_policy      = "Always"

  container {
    name   = "frontend"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      REACT_APP_API_URL = "http://${local.name_prefix}-api.${var.location}.azurecontainer.io:8000/api"
      PORT              = "80"
    }



    liveness_probe {
      http_get {
        path   = "/"
        port   = 80
        scheme = "Http"
      }
      initial_delay_seconds = 60
      period_seconds        = 30
      timeout_seconds       = 10
      failure_threshold     = 3
    }

    readiness_probe {
      http_get {
        path   = "/"
        port   = 80
        scheme = "Http"
      }
      initial_delay_seconds = 30
      period_seconds        = 10
      timeout_seconds       = 5
      failure_threshold     = 3
    }
  }

  tags = local.common_tags
}

# Random password for Django secret key
resource "random_password" "django_secret" {
  length  = 50
  special = true
}

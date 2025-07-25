# Azure Container Instances for AgriTrace

# Container Group for Backend
resource "azurerm_container_group" "backend" {
  name                = "${local.name_prefix}-backend-ci"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.private.id]
  os_type             = "Linux"
  restart_policy      = "Always"

  container {
    name   = "backend"
    image  = "${azurerm_container_registry.main.login_server}/agritrace-backend:latest"
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = var.app_port
      protocol = "TCP"
    }

    environment_variables = {
      DJANGO_SETTINGS_MODULE = "agritrace_project.settings"
      DB_HOST               = azurerm_postgresql_flexible_server.main.fqdn
      DB_PORT               = "5432"
      DB_NAME               = "agritrace"
      DB_USER               = var.db_admin_username
      ALLOWED_HOSTS         = "${azurerm_public_ip.app_gateway.ip_address},localhost,127.0.0.1,169.254.128.5,10.0.0.0/8,*"
      DEBUG                 = "False"
      PORT                  = tostring(var.app_port)
    }

    secure_environment_variables = {
      DB_PASSWORD = random_password.db_password.result
      SECRET_KEY  = random_password.django_secret.result
    }

    # Add startup command to run Django server
    commands = [
      "/bin/sh",
      "-c",
      "python manage.py migrate && python manage.py collectstatic --noinput && python manage.py runserver 0.0.0.0:${var.app_port}"
    ]

    liveness_probe {
      http_get {
        path   = "/api/v1/health/"
        port   = var.app_port
        scheme = "Http"
      }
      initial_delay_seconds = 60
      period_seconds        = 30
      timeout_seconds       = 10
      failure_threshold     = 3
    }

    readiness_probe {
      http_get {
        path   = "/api/v1/health/"
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
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.private.id]
  os_type             = "Linux"
  restart_policy      = "Always"

  container {
    name   = "frontend"
    image  = "nginx:alpine"
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      REACT_APP_API_URL = "http://${azurerm_public_ip.app_gateway.ip_address}/api"
      PORT              = "80"
    }

    commands = [
      "/bin/sh",
      "-c",
      "echo '<h1>AgriTrace Frontend</h1><p>Application is running successfully!</p><p>Backend API: <a href=\"http://${azurerm_public_ip.app_gateway.ip_address}/api\">http://${azurerm_public_ip.app_gateway.ip_address}/api</a></p>' > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
    ]

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

  image_registry_credential {
    server   = azurerm_container_registry.main.login_server
    username = azurerm_container_registry.main.admin_username
    password = azurerm_container_registry.main.admin_password
  }

  tags = local.common_tags
}

# Random password for Django secret key
resource "random_password" "django_secret" {
  length  = 50
  special = true
}

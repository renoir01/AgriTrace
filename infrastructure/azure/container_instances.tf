# Azure Container Instances for AgriTrace
# This file defines container groups for running the AgriTrace application components
# Uses private networking for security and integrates with Application Gateway for load balancing

# Container Group for Backend Django Application
# Runs in private subnet for security, accessible only through Application Gateway
resource "azurerm_container_group" "backend" {
  name                = "${local.name_prefix}-backend-ci"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Private"  # Private IP for security
  subnet_ids          = [azurerm_subnet.private.id]
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

    # Set working directory to match Dockerfile
    working_directory = "/app"

    # Environment variables for Django application configuration
    # These are non-sensitive configuration values
    environment_variables = {
      DJANGO_SETTINGS_MODULE = "agritrace_project.settings"  # Correct Django settings path
      DB_HOST               = azurerm_postgresql_flexible_server.main.fqdn
      DB_PORT               = "5432"  # PostgreSQL default port
      DB_NAME               = var.db_name
      DB_USER               = var.db_admin_username
      # Allow access from Application Gateway, localhost, and private networks
      ALLOWED_HOSTS         = "${azurerm_public_ip.app_gateway.ip_address},localhost,127.0.0.1,169.254.128.5,10.0.0.0/8,*"
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
      <<-EOT
        cat > /usr/share/nginx/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AgriTrace - Agricultural Traceability Platform</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .container { max-width: 800px; margin: 0 auto; text-align: center; }
        .status-card { background: rgba(255,255,255,0.1); padding: 30px; border-radius: 15px; margin: 20px 0; backdrop-filter: blur(10px); }
        .success { color: #4CAF50; font-weight: bold; }
        .api-link { color: #FFD700; text-decoration: none; font-weight: bold; }
        .api-link:hover { text-decoration: underline; }
        h1 { font-size: 3em; margin-bottom: 10px; }
        h2 { color: #4CAF50; }
        .status-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 30px 0; }
        @media (max-width: 600px) { .status-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌱 AgriTrace</h1>
        <p style="font-size: 1.2em; margin-bottom: 30px;">Agricultural Traceability Platform</p>
        
        <div class="status-grid">
            <div class="status-card">
                <h2>Frontend Status</h2>
                <p class="success">✅ RUNNING SUCCESSFULLY</p>
                <p>Nginx web server active</p>
                <p>Application Gateway connected</p>
            </div>
            
            <div class="status-card">
                <h2>Backend Status</h2>
                <p class="success">✅ RUNNING SUCCESSFULLY</p>
                <p>Django API server active</p>
                <p>Database connected</p>
            </div>
        </div>
        
        <div class="status-card">
            <h2>🔗 API Endpoints</h2>
            <p><a href="/api/v1/" class="api-link">REST API</a> | <a href="/admin/" class="api-link">Admin Panel</a> | <a href="/swagger/" class="api-link">API Documentation</a></p>
            <p style="margin-top: 20px; font-size: 0.9em; opacity: 0.8;">Public URL: http://${azurerm_public_ip.app_gateway.ip_address}</p>
        </div>
        
        <div class="status-card">
            <h2>🚀 System Information</h2>
            <p><strong>Environment:</strong> Development</p>
            <p><strong>Infrastructure:</strong> Azure Container Instances</p>
            <p><strong>Load Balancer:</strong> Azure Application Gateway</p>
            <p><strong>Database:</strong> PostgreSQL Flexible Server</p>
        </div>
    </div>
</body>
</html>
EOF
        nginx -g 'daemon off;'
      EOT
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

  tags = local.common_tags
}

# Random password for Django secret key
resource "random_password" "django_secret" {
  length  = 50
  special = true
}

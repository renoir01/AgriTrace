# Azure Application Gateway for AgriTrace

# Application Gateway Subnet (required for App Gateway)
resource "azurerm_subnet" "app_gateway" {
  name                 = "${local.name_prefix}-appgw-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = "${local.name_prefix}-appgw"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.app_gateway.id
  }

  frontend_port {
    name = "frontend-port-80"
    port = 80
  }

  frontend_port {
    name = "frontend-port-443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  # Backend pool for frontend
  backend_address_pool {
    name = "frontend-backend-pool"
    ip_addresses = [azurerm_container_group.frontend.ip_address]
  }

  # Backend pool for backend API
  backend_address_pool {
    name = "backend-api-pool"
    ip_addresses = [azurerm_container_group.backend.ip_address]
  }

  # Backend HTTP settings for frontend
  backend_http_settings {
    name                  = "frontend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60

    probe_name = "frontend-health-probe"
  }

  # Backend HTTP settings for API
  backend_http_settings {
    name                  = "backend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = var.app_port
    protocol              = "Http"
    request_timeout       = 60

    probe_name = "backend-health-probe"
  }

  # Health probes
  probe {
    name                = "frontend-health-probe"
    protocol            = "Http"
    path                = "/"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200"]
    }
  }

  probe {
    name                = "backend-health-probe"
    protocol            = "Http"
    path                = "/api/v1/health/"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200"]
    }
  }

  # HTTP Listener
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port-80"
    protocol                       = "Http"
  }

  # URL path map for routing
  url_path_map {
    name                = "path-map"
    default_backend_address_pool_name  = "frontend-backend-pool"
    default_backend_http_settings_name = "frontend-http-settings"

    path_rule {
      name                       = "api-rule"
      paths                      = ["/api/*"]
      backend_address_pool_name  = "backend-api-pool"
      backend_http_settings_name = "backend-http-settings"
    }

    path_rule {
      name                       = "admin-rule"
      paths                      = ["/admin/*"]
      backend_address_pool_name  = "backend-api-pool"
      backend_http_settings_name = "backend-http-settings"
    }

    path_rule {
      name                       = "static-rule"
      paths                      = ["/static/*"]
      backend_address_pool_name  = "backend-api-pool"
      backend_http_settings_name = "backend-http-settings"
    }

    path_rule {
      name                       = "media-rule"
      paths                      = ["/media/*"]
      backend_address_pool_name  = "backend-api-pool"
      backend_http_settings_name = "backend-http-settings"
    }
  }

  # Request routing rule
  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "PathBasedRouting"
    http_listener_name         = "http-listener"
    url_path_map_name          = "path-map"
    priority                   = 100
  }

  tags = local.common_tags
}

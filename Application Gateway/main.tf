# Configure the Azure provider
terraform {
  required_version = "1.1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "wafpol-sit-hk-peak-i1_rg" {
  name     = var.wafpol-sit-hk-peak-i1_rg_name_var
  location = var.wafpol-sit-hk-peak-i1_rg_location_var
}

resource "azurerm_web_application_firewall_policy" "wafpol-sit-hk-peak-i1_firewallpolicy" {
  name                = var.wafpol-sit-hk-peak-i1_firewallpolicy_name_var
  resource_group_name = var.wafpol-sit-hk-peak-i1_rg_name_var
  location            = var.wafpol-sit-hk-peak-i1_firewallpolicy_location_var

  # custom rule loop
  dynamic "custom_rules" {
    for_each = toset(var.wafpol-sit-hk-peak-i1_custom_rules_var)
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type

      dynamic "match_conditions" {
        for_each = toset(custom_rules.value.match_conditions)
        content {

          dynamic "match_variables" {
            for_each = toset(match_conditions.value.match_variables)
            content {
              variable_name = match_variables.value.variable_name
              selector      = match_variables.value.selector
            }

          }

          operator           = match_conditions.value.operator
          negation_condition = match_conditions.value.negation_condition
          match_values       = match_conditions.value.match_values
        }
      }
      action = custom_rules.value.action
    }
  }

  policy_settings {
    enabled                     = var.wafpol-sit-hk-peak-i1_policysetting_enabled
    mode                        = var.wafpol-sit-hk-peak-i1_policysetting_mode
    request_body_check          = var.wafpol-sit-hk-peak-i1_policysetting_request_body_check
    file_upload_limit_in_mb     = var.wafpol-sit-hk-peak-i1_policysetting_mode_file_upload_limit_in_mb
    max_request_body_size_in_kb = var.wafpol-sit-hk-peak-i1_policysetting_mode_max_request_body_size_in_kb
  }

  # fixed managed
  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  depends_on = [azurerm_resource_group.wafpol-sit-hk-peak-i1_rg]
}

resource "azurerm_public_ip" "agw-sit-hk-peak-i1_publicip" {
  name                = var.agw-sit-hk-peak-i1_publicip_name
  resource_group_name = var.agw-sit-hk-peak-i1_resource_group_name
  location            = var.agw-sit-hk-peak-i1_location
  allocation_method   = "Static"
  sku = "Standard"

  depends_on = [azurerm_resource_group.wafpol-sit-hk-peak-i1_rg]
}

#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  agw_i1_backend_address_pool_name      = "agw-sit-hk-peak-i1-beap"
  agw_i1_frontend_port_name             = "agw-sit-hk-peak-i1-feport"
  agw_i1_frontend_ip_configuration_name = "agw-sit-hk-peak-i1-feip"
  agw_i1_http_setting_name              = "agw-sit-hk-peak-i1-be-htst"
  agw_i1_listener_name                  = "agw-sit-hk-peak-i1-httplstn"
  agw_i1_request_routing_rule_name      = "agw-sit-hk-peak-i1-rqrt"
  agw_i1_redirect_configuration_name    = "agw-sit-hk-peak-i1-rdrcfg"
}

resource "azurerm_application_gateway" "agw-sit-hk-peak-i1" {
  name                = var.agw-sit-hk-peak-i1_name_var
  resource_group_name = var.agw-sit-hk-peak-i1_resource_group_name
  location            = var.agw-sit-hk-peak-i1_location
  firewall_policy_id  = azurerm_web_application_firewall_policy.wafpol-sit-hk-peak-i1_firewallpolicy.id

  # Azone
  zones = ["1", "2", "3"]

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  gateway_ip_configuration {
    name      = var.agw-sit-hk-peak-i1_gateway_ip_configuration_name
    subnet_id = var.agw-sit-hk-peak-i1_vnet_subnet_id
  }

  frontend_port {
    name = local.agw_i1_frontend_port_name
    port = var.agw-sit-hk-peak-i1_frontend_port
  }

  frontend_ip_configuration {
    name                 = local.agw_i1_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw-sit-hk-peak-i1_publicip.id
  }

  # dyanmic
  dynamic "backend_address_pool" {
    for_each = toset(var.agw-sit-hk-peak-i1_backend_address_pool_var)
    content {
      name = backend_address_pool.value.name
      fqdns = backend_address_pool.value.fqdns
    }
  }
  
  dynamic "backend_http_settings" {
    for_each = toset(var.agw-sit-hk-peak-i1_backend_http_settings_var)
    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = toset(var.agw-sit-hk-peak-i1_http_listener_var)
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
    }
  }

  dynamic "request_routing_rule" {
    for_each = toset(var.agw-sit-hk-peak-i1_request_routing_rule_var)
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }

  autoscale_configuration {
    min_capacity = var.agw-sit-hk-peak-i1_sku_capability_min
    max_capacity = var.agw-sit-hk-peak-i1_sku_capability_max
  }

  depends_on = [azurerm_public_ip.agw-sit-hk-peak-i1_publicip, azurerm_web_application_firewall_policy.wafpol-sit-hk-peak-i1_firewallpolicy]
}
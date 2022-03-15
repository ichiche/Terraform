# Configure the Azure provider
terraform {
  required_version = "1.1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.97.0"
    }
  }

  backend "azurerm" {}
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
  resource_group_name = var.wafpol-sit-hk-peak-i1_rg_name_var
  location            = var.agw-sit-hk-peak-i1_location
  allocation_method   = "Static"
  sku = "Standard"

  depends_on = [azurerm_resource_group.wafpol-sit-hk-peak-i1_rg]
}

#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  agw_i1_backend_address_pool_name              = "agw-sit-hk-peak-i1-beap"
  agw_i1_frontend_port_name                     = "agw-sit-hk-peak-i1-feport"
  agw_i1_frontend_ip_configuration_name_public  = "agw-sit-hk-peak-i1-feip-public"
  agw_i1_frontend_ip_configuration_name_private = "agw-sit-hk-peak-i1-feip-private"
  agw_i1_http_setting_name                      = "agw-sit-hk-peak-i1-be-htst"
  agw_i1_listener_name                          = "agw-sit-hk-peak-i1-httplstn"
  agw_i1_request_routing_rule_name              = "agw-sit-hk-peak-i1-rqrt"
  agw_i1_redirect_configuration_name            = "agw-sit-hk-peak-i1-rdrcfg"
}

resource "azurerm_application_gateway" "agw-sit-hk-peak-i1" {
  name                = var.agw-sit-hk-peak-i1_name_var
  resource_group_name = var.wafpol-sit-hk-peak-i1_rg_name_var
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
    name                          = local.agw_i1_frontend_ip_configuration_name_public
    public_ip_address_id          = azurerm_public_ip.agw-sit-hk-peak-i1_publicip.id
  }

  frontend_ip_configuration {
    name                          = local.agw_i1_frontend_ip_configuration_name_private
    subnet_id                     = var.agw-sit-hk-peak-i1_vnet_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.agw-sit-hk-peak-i1_frontend_private_ip
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

resource "azurerm_resource_group" "aks_rg" {
  name     = var.aks_resource_group_name
  location = var.aks_location

  depends_on = [azurerm_application_gateway.agw-sit-hk-peak-i1]
}

resource "azurerm_private_dns_zone" "dns" {
  name                = var.private_dns_zone_name
  resource_group_name = var.private_dns_zone_resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "associate_hub_vnet" {
  name                  = "hub-vnet"
  resource_group_name   = var.private_dns_zone_resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.hub_vnet_id

  depends_on = [azurerm_private_dns_zone.dns]
}

resource "azurerm_user_assigned_identity" "aks_cluster_identity" {
  name                = var.aks_cluster_identity_name
  location            = var.aks_location
  resource_group_name = var.aks_resource_group_name

  depends_on = [azurerm_resource_group.aks_rg, azurerm_private_dns_zone.dns]
}

resource "azurerm_role_assignment" "aks_vnet" {
  principal_id                     = azurerm_user_assigned_identity.aks_cluster_identity.principal_id
  role_definition_name             = "Contributor"
  scope                            = var.aks_vnet_id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_user_assigned_identity.aks_cluster_identity]
}

resource "azurerm_role_assignment" "private_dns_zone" {
  principal_id                     = azurerm_user_assigned_identity.aks_cluster_identity.principal_id
  role_definition_name             = "Private DNS Zone Contributor"
  scope                            = azurerm_private_dns_zone.dns.id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_user_assigned_identity.aks_cluster_identity]
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                                = var.aks_name
  location                            = var.aks_location
  resource_group_name                 = var.aks_resource_group_name
  kubernetes_version                  = var.kubernetes_version
  dns_prefix_private_cluster          = var.aks_dns_prefix 
  sku_tier                            = var.sku_tier
  node_resource_group                 = var.node_resource_group_name
  private_dns_zone_id                 = azurerm_private_dns_zone.dns.id
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  azure_policy_enabled                = true
  local_account_disabled              = false
  tags                                = var.tags

  default_node_pool {
    name                   = var.system_node_pool_name
    min_count              = var.system_node_pool_min_count
    max_count              = var.system_node_pool_max_count
    os_sku                 = var.system_node_pool_os_sku
    os_disk_type           = var.system_node_pool_os_disk_type 
    os_disk_size_gb        = var.system_node_pool_os_disk_size_gb
    vm_size                = var.system_node_pool_vm_size
    vnet_subnet_id         = var.system_node_pool_subnet_id
    max_pods               = var.system_node_pool_max_pods 
    availability_zones     = [1,2,3]
    type                   = "VirtualMachineScaleSets"
    enable_auto_scaling    = true
    enable_host_encryption = true
    enable_node_public_ip  = false
  }

  identity {
    type = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_cluster_identity.id
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed            = true
      azure_rbac_enabled = true
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_mode      = "transparent"
    load_balancer_sku = "Standard"
    outbound_type     = var.outbound_type
    network_policy    = var.network_policy
  }
  
  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.agw-sit-hk-peak-i1.id
  }

  oms_agent {
    log_analytics_workspace_id = var.log_workspace_id
  }

  depends_on = [azurerm_role_assignment.aks_vnet, azurerm_role_assignment.private_dns_zone]
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool_1" {
  name                   = var.user_node_pool_1_name
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks_cluster.id
  min_count              = var.user_node_pool_1_min_count
  max_count              = var.user_node_pool_1_max_count
  orchestrator_version   = var.user_node_pool_1_orchestrator_version
  os_sku                 = var.user_node_pool_1_os_sku
  os_disk_type           = var.user_node_pool_1_os_disk_type 
  os_disk_size_gb        = var.user_node_pool_1_os_disk_size_gb
  vm_size                = var.user_node_pool_1_vm_size
  vnet_subnet_id         = var.system_node_pool_subnet_id # At this time the vnet_subnet_id must be the same for all node pools in the cluster
  mode                   = var.user_node_pool_1_mode
  max_pods               = var.user_node_pool_1_max_pods
  availability_zones     = [1,2,3]
  enable_auto_scaling    = true
  enable_host_encryption = true
  enable_node_public_ip  = false
  tags                   = var.tags

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}

data "azurerm_user_assigned_identity" "agic" {
  name                = var.agic_identity_name
  resource_group_name = var.node_resource_group_name

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}

resource "azurerm_role_assignment" "agic" {
  principal_id                     = data.azurerm_user_assigned_identity.agic.principal_id
  role_definition_name             = "Contributor"
  scope                            = azurerm_resource_group.wafpol-sit-hk-peak-i1_rg.id
  skip_service_principal_aad_check = true

  depends_on = [data.azurerm_user_assigned_identity.agic]
}

resource "azurerm_role_assignment" "acr1" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id # This role is assigned to the kubelet managed identity
  role_definition_name             = "AcrPull"
  scope                            = var.container_registry_id_1
  skip_service_principal_aad_check = true

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}

resource "azurerm_role_assignment" "acr2" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id # This role is assigned to the kubelet managed identity
  role_definition_name             = "AcrPull"
  scope                            = var.container_registry_id_2
  skip_service_principal_aad_check = true

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}
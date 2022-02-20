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

resource "azurerm_resource_group" "aks_rg" {
  name     = var.aks_resource_group_name
  location = var.aks_location
}

resource "azurerm_user_assigned_identity" "aks_cluster_identity" {
  name                = var.aks_cluster_identity_name
  location            = var.aks_location
  resource_group_name = var.aks_resource_group_name

  depends_on = [azurerm_resource_group.aks_rg]
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
  scope                            = var.private_dns_zone_id
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
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  azure_policy_enabled                = true
  local_account_disabled              = true
  tags                                = var.tags

  default_node_pool {
    name               = var.system_node_pool_name
    node_count         = var.system_node_pool_vm_count
    os_sku             = var.system_node_pool_os_sku
    os_disk_type       = var.system_node_pool_os_disk_type 
    os_disk_size_gb    = var.system_node_pool_os_disk_size_gb
    vm_size            = var.system_node_pool_vm_size
    vnet_subnet_id     = var.system_node_pool_subnet_id
    max_pods           = var.system_node_pool_max_pods 
    availability_zones = [1,2,3]
    type               = "VirtualMachineScaleSets"
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
    #network_policy    = var.network_policy
  }
  
  oms_agent {
    log_analytics_workspace_id = var.log_workspace_id
  }

  depends_on = [azurerm_role_assignment.aks_vnet, azurerm_role_assignment.private_dns_zone]
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool_1" {
  name                  = var.user_node_pool_1_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  node_count            = var.user_node_pool_1_vm_count
  orchestrator_version  = var.user_node_pool_1_orchestrator_version
  os_sku                = var.user_node_pool_1_os_sku
  os_disk_type          = var.user_node_pool_1_os_disk_type 
  os_disk_size_gb       = var.user_node_pool_1_os_disk_size_gb
  vm_size               = var.user_node_pool_1_vm_size
  vnet_subnet_id        = var.system_node_pool_subnet_id # At this time the vnet_subnet_id must be the same for all node pools in the cluster
  mode                  = var.user_node_pool_1_mode
  max_pods              = var.user_node_pool_1_max_pods
  availability_zones    = [1,2,3]
  tags                  = var.tags

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.container_registry_id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}


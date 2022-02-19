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

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                       = var.aks_name
  location                   = var.aks_location
  resource_group_name        = var.aks_resource_group_name
  kubernetes_version         = var.kubernetes_version
  dns_prefix                 = var.aks_dns_prefix 
  local_account_disabled     = true
  tags                       = var.tags

  default_node_pool {
    name               = var.system_node_pool_name
    node_count         = var.system_node_pool_vm_count
    os_sku             = var.os_sku
    os_disk_type       = var.os_disk_type 
    os_disk_size_gb    = var.os_disk_size_gb
    vm_size            = var.system_node_pool_vm_size
    vnet_subnet_id     = var.system_node_pool_subnet_id
    max_pods           = var.system_node_pool_max_pods 
    availability_zones = [1,2,3]
    type               = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
      azure_rbac_enabled = true
    }
  }

  network_profile {
    network_plugin = "azure"
    network_mode   = "transparent"
  }
  
  oms_agent {
    log_analytics_workspace_id = var.log_workspace_id
  }

  depends_on = [azurerm_resource_group.aks_rg]
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.container_registry_id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}
variable "wafpol-sit-hk-peak-i1_rg_location_var" {
  description = "Azure Region of Resource Group of WAF Policy"
  type    = string
  default = "East Asia"
}

variable "wafpol-sit-hk-peak-i1_rg_name_var" {
  description = "Resource Group of the WAF Policy"
  type    = string
  default = "rg-sit-hk-peak-app-gateway"
}

variable "wafpol-sit-hk-peak-i1_firewallpolicy_name_var" {
  description = "Name of WAF Policy"
  type    = string
  default = "wafpol-sit-hk-peak-i1"
}

variable "wafpol-sit-hk-peak-i1_firewallpolicy_location_var" {
  description = "Azure Region of WAF Policy"
  type    = string
  default = "East Asia"
}

variable "wafpol-sit-hk-peak-i1_custom_rules_var" {
  default = [
    {
      action = "Block"
      name                       = "sample-customrule1"
      priority                   = 100
      rule_type                  = "MatchRule"
      match_conditions           = [{
        operator           = "IPMatch"
        negation_condition = false
        match_values       = ["8.8.8.8"]
        match_variables = [{
          variable_name = "RequestHeaders"
          selector = "UserAgent"
        }]
      }]
    }
  ]
  type    = list
}

variable "wafpol-sit-hk-peak-i1_policysetting_enabled" {
  description = "policy setting - enable"
  default = true
}

variable "wafpol-sit-hk-peak-i1_policysetting_mode" {
  description = "policy setting - mode"
  default = "Detection"
  type    = string
}

variable "wafpol-sit-hk-peak-i1_policysetting_request_body_check" {
  description = "policy setting - request_body_check"
  default = true
}

variable "wafpol-sit-hk-peak-i1_policysetting_mode_file_upload_limit_in_mb" {
  description = "policy setting - file_upload_limit_in_mb"
  default = "100"
  type    = string
}

variable "wafpol-sit-hk-peak-i1_policysetting_mode_max_request_body_size_in_kb" {
  description = "policy setting - max_request_body_size_in_kb"
  default = "128"
  type    = string
}

variable "agw-sit-hk-peak-i1_location" {
  type    = string
  default = "East Asia"
}

variable "agw-sit-hk-peak-i1_name_var" {
  type    = string
  default = "agw-sit-hk-peak-i1"
}

variable "agw-sit-hk-peak-i1_publicip_name" {
  type    = string
  default = "pip-agw-sit-hk-peak-i1"
}

# autoscale_configuration (min 6, max 40)
variable "agw-sit-hk-peak-i1_sku_capability_min" {
  type    = string
  default = "6"
}

variable "agw-sit-hk-peak-i1_sku_capability_max" {
  type    = string
  default = "40"
}

variable "agw-sit-hk-peak-i1_gateway_ip_configuration_name" {
  type    = string
  default = "gateway-ip-configuration"
}

variable "agw-sit-hk-peak-i1_vnet_subnet_id" {
  description = "agw-sit-hk-peak-i1 vnet subnet id"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vnet-hub-prd-eas-001/subnets/subnet-poc-hk-peak-appgateway"
}

variable "agw-sit-hk-peak-i1_frontend_port" {
  type    = string
  default = "80"
}

variable "agw-sit-hk-peak-i1_frontend_private_ip" {
  type    = string
  default = "10.10.2.4"
}

# dummy address
variable "agw-sit-hk-peak-i1_backend_address_pool_var" {
  type    = list
  default = [
    {
      name = "agw-sit-hk-peak-i1-beap"
      fqdns = ["8.8.8.8"]
    }
  ]
}

variable "agw-sit-hk-peak-i1_backend_http_settings_var" {
  type    = list
  default = [
    {
      name                  = "agw-sit-hk-peak-i1-be-htst"
      cookie_based_affinity = "Disabled"
      port                  = "80"
      protocol              = "Http"
      request_timeout       = "20"
    }
  ]
}

variable "agw-sit-hk-peak-i1_http_listener_var" {
  type    = list
  default = [
    {
      name                           = "agw-sit-hk-peak-i1-httplstn"
      frontend_ip_configuration_name = "agw-sit-hk-peak-i1-feip-private"
      frontend_port_name             = "agw-sit-hk-peak-i1-feport"
      protocol                       = "Http"
    }
  ]
}

variable "agw-sit-hk-peak-i1_request_routing_rule_var" {
  type    = list
  default = [
    {
      name                       = "agw-sit-hk-peak-i1-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "agw-sit-hk-peak-i1-httplstn"
      backend_address_pool_name  = "agw-sit-hk-peak-i1-beap"
      backend_http_settings_name = "agw-sit-hk-peak-i1-be-htst"
    }
  ]
}

variable "private_dns_zone_resource_group_name" {
  description = "Resource Group of Private DNS Zone"
  type    = string
  default = "rg-privatedns-core-poc-eas"
}

variable "private_dns_zone_resource_group_location" {
  description = "Azure Region of Resource Group of Private DNS Zone. Private DNS Zone is Global Region."
  type    = string
  default = "East Asia"
}

variable "private_dns_zone_name" {
  description = "Name of Private DNS Zone"
  type    = string
  default = "privatelink.eastasia.azmk8s.io"
}

variable "hub_vnet_id" {
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vnet-hub-prd-sea-001"
}

variable "aks_resource_group_name" {
  description = "Resource Group of Azure Kubernetes Service (Managed Service). This is NOT the Resource Group of AKS Agent Nodes (VMSS)"
  type    = string
  default = "rg-aks-core-poc-eas"
}

variable "node_resource_group_name" {
  description = "The name of the Resource Group where the AKS Agent Nodes (VMSS) exist. All Node Pools will be provisioned within this resource group"
  type    = string
  default = "rg-aksnode-core-poc-eas"
}

variable "disk_encryption_set_id" {
  description = "Retrieve the DiskEncryptionSet value"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/KeyVault/providers/Microsoft.Compute/diskEncryptionSets/DiskEncryptionSet-AKS-Prod"
}

variable "aks_cluster_identity_name" {
  description = "User Assigned Identity of Azure Kubernetes Service (Managed Service)"
  type    = string
  default = "id-aks-sit-eas-001"
}

variable "aks_location" {
  description = "Azure Region of Azure Kubernetes Service (Managed Service)"
  type    = string
  default = "East Asia"
}

variable "aks_name" {
  description = "Name of Azure Kubernetes Service (Managed Service)"
  type    = string
  default = "aks-sit-eas-001"
}

variable "agic_identity_name" {
  description = "User Assigned Identity of AGIC, naming must be 'ingressapplicationgateway-' plus the value of aks_name"
  type    = string
  default = "ingressapplicationgateway-aks-sit-eas-001"
  #default = format("ingressapplicationgateway-%s!", var.aks_name)
}

variable "kubernetes_version" {
  description = "Run PowerShell Az Module Command: Get-AzAksVersion -Location 'East Asia' to retrieve available AKS version"
  type        = string
  default     = "1.22.4"
}

variable "aks_dns_prefix" {
  description = "DNS prefix is used with hosted Kubernetes API server FQDN. If not specified, generate a hostname using the managed cluster and resource group names"
  type    = string
  default = "aksdemo"
}

variable "sku_tier" {
  description = "Kubernetes API server uptime of 99.5% (Free) or 99.9% (Paid without AZone), 99.95% (Paid with AZone). Supported values are 'Free' and 'Paid'"
  type    = string
  default = "Free"
}

variable "outbound_type" {
  description = <<EOT
  1. The outbound (egress) routing method which should be used for Kubernetes Cluster. 
  2. Supported values are 'loadBalancer' and 'userDefinedRouting'. 
  3. If 'userDefinedRouting' is used, Default route 0.0.0.0/0 from route table must be associated with subnet prior to AKS creation.
  4. Default route 0.0.0.0/0 must have the next hops of VirtualAppliance or VirtualNetworkGateway only.
  5. If AKS and VirtualAppliance / VirtualNetworkGateway locate in different Virtual Networks, those Virtual Networks must be peered prior to AKS creation.
  EOT
  type        = string
  default     = "userDefinedRouting"
}

variable "network_policy" {
  description = "Supported values are 'azure' and 'calico'"
  type        = string
  default     = "azure"
}

variable "aks_vnet_id" {
  description = "Resource Id of AKS VNet"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vnet-hub-prd-eas-001"
}

variable "log_workspace_id" {
  description = "Resource Id of Log Analytics Workspace for Insight"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Log/providers/Microsoft.OperationalInsights/workspaces/log-analytics-aks-prd-eas-001"
}

variable "container_registry_id_1" {
  description = "Resource Id of Azure Container Registry (ACR)"
  type        = string
  default     = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/ContainerRegistry/providers/Microsoft.ContainerRegistry/registries/cvcoreprdeas001"
}

variable "container_registry_id_2" {
  description = "Resource Id of Azure Container Registry (ACR)"
  type        = string
  default     = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/ContainerRegistry/providers/Microsoft.ContainerRegistry/registries/cvcoreprdeas002"
}

variable "tags" {
  description = "Specifies tags for the resources"
  type        = map
  default     = {
    Environment = "SIT"
    CreatedBy = "Terraform"
  }
}

# Default Node Pool (System Node Pool) Section Start
variable "system_node_pool_name" {
  description = "Name must start with a lowercase letter, have max length of 12, and only have characters a-z0-9"
  type        = string
  default     = "systempool"
}

variable "system_node_pool_min_count" {
  description = "With Node Auto Scale enabled, minimum number of node. Recommend at least 2 nodes for System Node Pool"
  type    = number
  default = 1
}

variable "system_node_pool_max_count" {
  description = "With Node Auto Scale enabled, maximum number of node"
  type    = number
  default = 3
}

variable "system_node_pool_os_sku" {
  description = "OS SKU of the agent node pool. Supported values are 'Ubuntu' and 'CBLMariner'"
  type    = string
  default = "Ubuntu"
}

variable "system_node_pool_os_disk_type" {
  description = "Supported values are 'Managed' and 'Ephemeral'"
  type        = string
  default     = "Managed"
}

variable "system_node_pool_os_disk_size_gb" {
  description = "OS Disk Size"
  type    = number
  default = 128
}

variable "system_node_pool_vm_size" {
  description = "If Ephemeral is enabled, selected VM size must has a cache and temp storage larger than node OS disk size"
  type        = string
  default     = "standard_d2s_v4"
}

variable "system_node_pool_subnet_id" {
  description = "Resource Id of Subnet for AKS VNet customization"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vnet-hub-prd-eas-001/subnets/subnet-poc-hk-peak-aks"
}

variable "system_node_pool_max_pods" {
  description = "The maximum number of pods per node in an AKS cluster is 250"
  type    = number
  default = 30
}
# Default Node Pool (System Node Pool) Section End

# User Node Pool Section Start
variable "user_node_pool_1_name" {
  description = "Name must start with a lowercase letter, have max length of 12, and only have characters a-z0-9"
  type        = string
  default     = "app1"
}

variable "user_node_pool_1_min_count" {
  description = "With Node Auto Scale enabled, minimum number of node"
  type    = number
  default = 1
}

variable "user_node_pool_1_max_count" {
  description = "With Node Auto Scale enabled, maximum number of node"
  type    = number
  default = 3
}

variable "user_node_pool_1_orchestrator_version" {
  description = "Version of Kubernetes used for the Agent Pool"
  type        = string
  default     = "1.22.4"
}

variable "user_node_pool_1_os_sku" {
  description = "OS SKU of the agent node pool. Supported values are 'Ubuntu' and 'CBLMariner'"
  type    = string
  default = "Ubuntu"
}

variable "user_node_pool_1_os_disk_type" {
  description = "Supported values are 'Managed' and 'Ephemeral'"
  type        = string
  default     = "Managed"
}

variable "user_node_pool_1_os_disk_size_gb" {
  description = "OS Disk Size"
  type    = number
  default = 128
}

variable "user_node_pool_1_vm_size" {
  description = "If Ephemeral is enabled, selected VM size must has a cache and temp storage larger than node OS disk size"
  type        = string
  default     = "standard_d2s_v4"
}

variable "user_node_pool_1_mode" {
  description = "Supported values are 'System' and 'User'"
  type        = string
  default     = "User"
}

variable "user_node_pool_1_max_pods" {
  description = "The maximum number of pods per node in an AKS cluster is 250"
  type    = number
  default = 30
}
# User Node Pool Section End
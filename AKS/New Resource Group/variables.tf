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
  default     = "loadBalancer"
}

variable "network_policy" {
  description = "Supported values are 'azure' and 'calico'"
  type        = string
  default     = "azure"
}

variable "aks_vnet_id" {
  description = "Resource Id of AKS VNet"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vn-poc-hk-peak"
}

variable "private_dns_zone_id" {
  description = "Resource Id of Private DNS Zone"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/rg-privatedns-core-poc-eas/providers/Microsoft.Network/privateDnsZones/privatelink.eastasia.azmk8s.io"
}

variable "log_workspace_id" {
  description = "Resource Id of Log Analytics Workspace for Insight"
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Log/providers/Microsoft.OperationalInsights/workspaces/log-analytics-aks-prd-eas-001"
}

variable "container_registry_id" {
  description = "Resource Id of Azure Container Registry (ACR)"
  type        = string
  default     = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/ContainerRegistry/providers/Microsoft.ContainerRegistry/registries/cvcoreprdeas001"
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
  default = 2
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
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vn-poc-hk-peak/subnets/subnet-poc-hk-peak-aks"
}

variable "system_node_pool_max_pods" {
  description = "The maximum number of pods per node in an AKS cluster is 250"
  type    = number
  default = 80
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
  default = 80
}
# User Node Pool Section End

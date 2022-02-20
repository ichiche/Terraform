variable "resource_group_name" {
  type    = string
  default = "rg-aks-core-poc-eas"
}

variable "aks_location" {
  type    = string
  default = "East Asia"
}

variable "aks_name" {
  type    = string
  default = "aks-sit-eas-001"
}

variable "kubernetes_version" {
  description = "Run PowerShell Az Module Command: Get-AzAksVersion -Location 'East Asia' to retrieve available AKS version"
  type        = string
  default     = "1.22.4"
}

variable "aks_dns_prefix" {
  type    = string
  default = "ichichedemo"
}

variable "system_node_pool_name" {
  description = "Name must start with a lowercase letter, have max length of 12, and only have characters a-z0-9"
  type        = string
  default     = "systempool"
}

variable "system_node_pool_vm_count" {
  type    = number
  default = 2
}

variable "os_sku" {
  type    = string
  default = "Ubuntu"
}

variable "os_disk_type" {
  description = "Enter 'Managed' or 'Ephemeral'"
  type        = string
  default     = "Managed"
}

variable "os_disk_size_gb" {
  type    = number
  default = 128
}

variable "system_node_pool_vm_size" {
  description = "If Ephemeral is enabled, target VM size must has a cache larger than node OS disk configuration"
  type        = string
  default     = "standard_d2s_v4"
}

variable "system_node_pool_subnet_id" {
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vn-poc-hk-peak/subnets/subnet-poc-hk-peak-aks"
}

variable "system_node_pool_max_pods" {
  type    = number
  default = 80
}

variable "log_workspace_id" {
  type    = string
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Log/providers/Microsoft.OperationalInsights/workspaces/log-analytics-aks-prd-eas-001"
}

variable "container_registry_id" {
  description = "Require to assign 'User Access Administrator' to AzureRunAsAccount on Container Registry"
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
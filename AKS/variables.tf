variable "aks_resource_group_name" {
  default = "rg-aks-core-poc-eas"
  type    = string
}

variable "aks_location" {
  default = "eastasia"
  type    = string
}

variable "aks_name" {
  default = "aks-sit-eas-001"
  type    = string
}

variable "kubernetes_version" {
  default = "1.22.4"
  type    = string
}

variable "aks_dns_prefix" {
  default = "ichichedemo"
  type    = string
}

variable "system_node_pool_name" {
  description = "Name must start with a lowercase letter, have max length of 12, and only have characters a-z0-9"
  default     = "systempool"
  type        = string
}

variable "system_node_pool_vm_count" {
  default = 2
  type    = number
}

variable "os_sku" {
  default = "Ubuntu"
  type    = string
}

variable "os_disk_type" {
  description = "Enter 'Managed' or 'Ephemeral'"
  default     = "Managed"
  type        = string
}

variable "os_disk_size_gb" {
  default = 128
  type    = number
}

variable "system_node_pool_vm_size" {
  description = "If Ephemeral is enabled, VM size that must has a cache larger than node OS disk configuration"
  default     = "standard_d2s_v4"
  type        = string
}

variable "system_node_pool_subnet_id" {
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vn-poc-hk-peak/subnets/subnet-poc-hk-peak-aks"
  type    = string
}

variable "system_node_pool_max_pods" {
  default = 80
  type    = number
}

variable "log_workspace_id" {
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Log/providers/Microsoft.OperationalInsights/workspaces/log-analytics-aks-prd-eas-001"
  type    = string
}

variable "container_registry_id" {
  default     = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/ContainerRegistry/providers/Microsoft.ContainerRegistry/registries/cvcoreprdeas001"
  type        = string
}

variable "tags" {
  description = "Specifies tags for the resources"
  default     = {
    Environment = "SIT"
    createdWith = "Terraform"
  }
}
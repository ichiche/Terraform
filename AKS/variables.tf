variable "aks_resource_group_name" {
  default = "AKS-Demo"
  type    = string
}

variable "aks_location" {
  default = "southeastasia"
  type    = string
}

variable "aks_name" {
  default = "aks-sit-sea-001"
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
  default = "systempool"
  type    = string
}

variable "system_node_pool_vm_count" {
  default = 2
  type    = number
}

variable "system_node_pool_vm_size" {
  default = "Standard_D2s_v4"
  type    = string
}

variable "os_sku" {
  default = "Ubuntu"
  type    = string
}

variable "os_disk_type" {
  default = "Ephemeral"
}

variable "system_node_pool_subnet_id" {
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vn-sit-hk-peak/subnets/subnet-sit-hk-peak-aks"
  type    = string
}

variable "system_node_pool_max_pods" {
  default = 80
  type    = number
}

variable "log_workspace_id" {
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Log/providers/Microsoft.OperationalInsights/workspaces/log-analytics-aks-prd-sea-001"
  type    = string
}

variable "wafpol-sit-hk-peak-i1_rg_location_var" {
  description = "resource group location for the wafpol-sit-hk-peak-i1 policy"
  type    = string
  default = "East Asia"
}

variable "wafpol-sit-hk-peak-i1_rg_name_var" {
  description = "resource group name for the wafpol-sit-hk-peak-i1 policy"
  type    = string
  default = "rg-sit-hk-peak-app-gateway"
}

variable "wafpol-sit-hk-peak-i1_firewallpolicy_name_var" {
  description = "resource naming for wafpol-sit-hk-peak-i1"
  type    = string
  default = "wafpol-sit-hk-peak-i1"
}

variable "wafpol-sit-hk-peak-i1_firewallpolicy_location_var" {
  description = "resource location for wafpol-sit-hk-peak-i1"
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
  default = "/subscriptions/7a2dec40-395f-45a9-b6b0-bef1593ce760/resourceGroups/Network/providers/Microsoft.Network/virtualNetworks/vn-poc-hk-peak/subnets/subnet-poc-hk-peak-appgateway-02"
}

variable "agw-sit-hk-peak-i1_frontend_port" {
  type    = string
  default = "80"
}

variable "agw-sit-hk-peak-i1_frontend_private_ip" {
  type    = string
  default = "10.1.18.4"
}

# dummy address
variable "agw-sit-hk-peak-i1_backend_address_pool_var" {
  default = [
    {
      name = "agw-sit-hk-peak-i1-beap"
      fqdns = ["8.8.8.8"]
    }
  ]
  type    = list
}

variable "agw-sit-hk-peak-i1_backend_http_settings_var" {
  default = [
    {
      name                  = "agw-sit-hk-peak-i1-be-htst"
      cookie_based_affinity = "Disabled"
      port                  = "80"
      protocol              = "Http"
      request_timeout       = "20"
    }
  ]
  type    = list
}

variable "agw-sit-hk-peak-i1_http_listener_var" {
  default = [
    {
      name                           = "agw-sit-hk-peak-i1-httplstn"
      frontend_ip_configuration_name = "agw-sit-hk-peak-i1-feip-private"
      frontend_port_name             = "agw-sit-hk-peak-i1-feport"
      protocol                       = "Http"
    }
  ]
  type    = list
}

variable "agw-sit-hk-peak-i1_request_routing_rule_var" {
  default = [
    {
      name                       = "agw-sit-hk-peak-i1-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "agw-sit-hk-peak-i1-httplstn"
      backend_address_pool_name  = "agw-sit-hk-peak-i1-beap"
      backend_http_settings_name = "agw-sit-hk-peak-i1-be-htst"
    }
  ]
  type    = list
}
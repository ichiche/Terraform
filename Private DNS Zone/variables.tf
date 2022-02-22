variable "private_dns_zone_resource_group_name" {
  type    = string
  default = "rg-privatedns-core-poc-eas"
}

variable "private_dns_zone_resource_group_location" {
  type    = string
  default = "East Asia"
}

variable "private_dns_zone_name" {
  type    = string
  default = "privatelink.eastasia.azmk8s.io"
}

variable "tags" {
  description = "Specifies tags for the resources"
  type        = map
  default     = {
    Environment = "All"
    CreatedBy = "Terraform"
  }
}
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

resource "azurerm_resource_group" "dns_rg" {
  name     = var.private_dns_zone_resource_group_name
  location = var.private_dns_zone_location
}

resource "azurerm_private_dns_zone" "dns" {
  name                = var.private_dns_zone_name
  resource_group_name = var.private_dns_zone_resource_group_name
  tags                = var.tags

  depends_on = [azurerm_resource_group.dns_rg]
}
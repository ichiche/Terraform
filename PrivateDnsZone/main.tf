# Configure the Azure provider
terraform {
  required_version = "1.1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = azurerm_resource_group.example.name
  tags                       = var.tags

  depends_on = [aws_iam_role_policy.example]
}
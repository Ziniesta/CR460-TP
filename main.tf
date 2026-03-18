terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  cloud {
    organization = "TP-CR460-YassineChoujaa"
    workspaces {
      name = "CR460-TP"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cr460-yassine"
  location = "canadacentral"
  tags = {
    environment = "TPcr460"
  }
}

module "avm-res-network-virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.8.1"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name          = "vnet-cr460-yassine"
  address_space = ["10.0.0.0/16"]

  subnets = {
    subnet1 = {
      name             = "subnet1"
      address_prefixes = ["10.0.0.0/24"]
    }
    subnet2 = {
      name             = "subnet2"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

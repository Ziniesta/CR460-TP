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

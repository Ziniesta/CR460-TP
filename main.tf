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

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-vm-cr460"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.avm-res-network-virtualnetwork.subnets.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_public_ip" "vm_pip" {
  name                = "pip-vm-cr460"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-cr460-yassine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  admin_username = "yassineAdmin"

  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  admin_ssh_key {
    username   = "yassineAdmin"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGfqpGLAGOSbWKMPGaStdBY5pF3562R3F0J0UaEHC58hwbEJKFkkPNJlFW5P7RjFXzmW52OZoRiD+eAedu3tzB6gUgK7Lk954BwKt8rFMcNa1DknQJfhU/FH6WFj87nwb/X7rC9HIOsk0pu+UdU+WMSZHwPdawj86qkHGsmG+e0DuEYtW2yyunKuSxP2FsRnXw6ASCC1KE4+YpYi8nJL5O+smBI/eFrUT/Gczjgq3NPKYZ9Z17dGzsUlS13E4bmtCOn2s7O9v4LAynwTsWoe/3gFdgtw/GW7uppXhXsoE0jHz8FKdIbMGcLPgHMZx7Q9gLlMuuYUmZUR1r3NyiY+kamPXiQiG4moX530LiKybjlp9bDNYA4cRTgrGhQvHQ4vh3zDQYHggQQI+TgvEwOmxPQd8p98VGLtui0lTPqnQcDYiakmpTV6Emu+5XakU9jmk8DZQltyAoB1mXJL7AmYKy0vqzOSS5r43178IkoDySW7eI0/owlPR+4n+KsYMlrxo/ZOF3syzPAEVMGD83uIfs3ZV7OHZQnSW+5knw02dfEfSSY2R5pKsCyKEcx1TIDixMFJ/HNGuuJjX++bGpJIO3rE9HhMy1092mILV8uwJxShlkrGKuTXO5/bijajsgrrs65tEktUbfx5Ys9/6eJ+8otJnbzpuvhNus2JqOvs0uNw== yassine@cr460"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
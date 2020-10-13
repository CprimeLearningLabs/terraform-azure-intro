terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.20, < 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-course-backend"
    container_name       = "tfstate"
    key                  = "cprime.terraform.labs.tfstate"
  }
  required_version = "~> 0.13.0"
}

provider "azurerm" {
  features {}
}

locals {
  region = var.region
  common_tags = {
    Environment = "Lab"
    Project     = "AZTF Training"
  }

  db_fw_rules = {
    private = {
      start_ip = cidrhost(azurerm_subnet.lab-private.address_prefixes[0],0)
      end_ip   = cidrhost(azurerm_subnet.lab-private.address_prefixes[0],255)
    },
    bastion = {
      start_ip = azurerm_linux_virtual_machine.lab-bastion.private_ip_address
      end_ip   = azurerm_linux_virtual_machine.lab-bastion.private_ip_address
    }
  }
  cluster_size = 2
}

resource "azurerm_resource_group" "lab" {
  name     = "aztf-labs-rg"
  location = local.region
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "lab" {
  name                = "aztf-labs-vnet"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}

resource "azurerm_subnet" "lab-public" {
  name                 = "aztf-labs-subnet-public"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "lab-private" {
  name                 = "aztf-labs-subnet-private"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "lab-public" {
  name                = "aztf-labs-public-sg"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "SSH-Access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefixes = azurerm_subnet.lab-public.address_prefixes
  }
}

resource "azurerm_network_security_group" "lab-private" {
  name                = "aztf-labs-private-sg"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "HTTP-Access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefixes = azurerm_subnet.lab-private.address_prefixes
  }

  security_rule {
    name                       = "SSH-Access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefixes = azurerm_subnet.lab-private.address_prefixes
  }
}

resource "azurerm_subnet_network_security_group_association" "lab-public" {
  subnet_id                 = azurerm_subnet.lab-public.id
  network_security_group_id = azurerm_network_security_group.lab-public.id
}

resource "azurerm_subnet_network_security_group_association" "lab-private" {
  subnet_id                 = azurerm_subnet.lab-private.id
  network_security_group_id = azurerm_network_security_group.lab-private.id
}

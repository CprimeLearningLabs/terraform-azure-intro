terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.20, < 3.0"
    }
  }
  backend "azurerm" {
    #resource_group_name  = "terraform-course-backend"
    storage_account_name = "aztfcoursebackend"
    container_name       = "tfstate"
    key                  = "cprime.terraform.labs.tfstate.0137"
  }
  required_version = "~> 0.13.0"
}

provider "azurerm" {
  features {}
}

locals {
  region = "westus2"
  common_tags = {
    Environment = "Lab"
    Project     = "AZTF Training"
  }
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
}

resource "azurerm_subnet_network_security_group_association" "lab-public" {
  subnet_id                 = azurerm_subnet.lab-public.id
  network_security_group_id = azurerm_network_security_group.lab-public.id
}

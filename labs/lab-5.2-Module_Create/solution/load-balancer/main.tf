terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.40, < 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

resource "azurerm_public_ip" "lab-lb" {
  name                         = "mod-aztf-labs-lb-public-ip"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = "Static"
  tags                         = var.tags
}

resource "azurerm_lb" "lab" {
  name                = "mod-aztf-labs-loadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.lab-lb.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "lab" {
  loadbalancer_id     = azurerm_lb.lab.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lab" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lab.id
  name                = "http-running-probe"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

resource "azurerm_lb_rule" "lab" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lab.id
  name                           = "mod-aztf-labs-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "publicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lab.id]
  probe_id                       = azurerm_lb_probe.lab.id
}

resource "azurerm_public_ip" "lab-lb" {
  name                         = "aztf-labs-lb-public-ip"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = "Static"
}

resource "azurerm_lb" "lab" {
  name                = "aztf-labs-loadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.lab-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "lab" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lab.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lab" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lab.id
  name                = "http-running-probe"
  protocol            = var.health_probe["protocol"]
  port                = var.health_probe["port"]
  request_path        = var.health_probe["request_path"]
}

resource "azurerm_lb_rule" "lab" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lab.id
  name                           = "aztf-labls-lb-rule"
  protocol                       = var.port_mapping["protocol"]
  frontend_port                  = var.port_mapping["frontend_port"]
  backend_port                   = var.port_mapping["backend_port"]
  frontend_ip_configuration_name = "publicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lab.id
  probe_id                       = azurerm_lb_probe.lab.id
}

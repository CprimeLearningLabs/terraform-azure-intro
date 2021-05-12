resource "azurerm_public_ip" "lab-lb" {
  name                         = "aztf-labs-lb-public-ip"
  location                     = local.region
  resource_group_name          = azurerm_resource_group.lab.name
  allocation_method            = "Static"
  tags                         = local.common_tags
}

resource "azurerm_lb" "lab" {
  name                = "aztf-labs-loadBalancer"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.lab-lb.id
  }

  tags = local.common_tags
}

resource "azurerm_lb_backend_address_pool" "lab" {
  loadbalancer_id     = azurerm_lb.lab.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lab" {
  resource_group_name = azurerm_resource_group.lab.name
  loadbalancer_id     = azurerm_lb.lab.id
  name                = "http-running-probe"
  protocol            = "Http"
  port                = 80
  request_path        = "/"
}

resource "azurerm_lb_rule" "lab" {
  resource_group_name            = azurerm_resource_group.lab.name
  loadbalancer_id                = azurerm_lb.lab.id
  name                           = "aztf-labs-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "publicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lab.id
  probe_id                       = azurerm_lb_probe.lab.id
}

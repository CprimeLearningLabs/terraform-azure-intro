
module "load-balancer" {
  source = "./load-balancer"

  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
  port_mapping = {
    protocol      = "Tcp"
    frontend_port = 80
    backend_port  = 80
  }
  health_probe = {
    protocol     = "Http"
    port         = 80
    request_path = "/"
  }
}


resource "azurerm_network_interface" "lab-app" {
  count               = local.cluster_size
  name                = "aztf-labs-nic-${count.index}"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "labConfiguration"
    subnet_id                     = azurerm_subnet.lab-private.id
    private_ip_address_allocation = "dynamic"
  }

  tags = local.common_tags
}


resource "azurerm_network_interface_backend_address_pool_association" "lab-app" {
  count                   = local.cluster_size
  network_interface_id    = azurerm_network_interface.lab-app[count.index].id
  ip_configuration_name   = "labConfiguration"
  backend_address_pool_id = module.load_balancer.backend_address_pool_id
}


resource "azurerm_availability_set" "lab-app" {
  name                         = "aztf-labs-avset"
  location                     = local.region
  resource_group_name          = azurerm_resource_group.lab.name
  tags                         = local.common_tags
}


resource "azurerm_linux_virtual_machine" "lab-app" {
  count                 = local.cluster_size
  name                  = "aztf-labs-app-vm-${count.index}"
  resource_group_name   = azurerm_resource_group.lab.name
  location              = local.region
  size                  = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.lab-app[count.index].id]
  availability_set_id   = azurerm_availability_set.lab-app.id
  admin_username        = "adminuser"
  admin_password        = var.vm_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = local.common_tags
}

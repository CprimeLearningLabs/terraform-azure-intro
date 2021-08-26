resource "azurerm_public_ip" "lab-bastion" {
  name                = "aztf-labs-public-ip"
  resource_group_name = azurerm_resource_group.lab.name
  location            = local.region
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "lab-bastion" {
  name                = "aztf-labs-nic"
  resource_group_name = azurerm_resource_group.lab.name
  location            = local.region

  ip_configuration {
    name                          = "aztf-labs-app-ipconfig"
    subnet_id                     = azurerm_subnet.lab-public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab-bastion.id
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "lab-bastion" {
  name                  = "aztf-labs-bastion-vm"
  resource_group_name   = azurerm_resource_group.lab.name
  location              = local.region
  size                  = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.lab-bastion.id]
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

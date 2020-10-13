resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "azurerm_postgresql_server" "lab" {
  name                = "aztf-labs-psqlserver-${random_integer.suffix.result}"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name

  sku_name                      = "B_Gen5_1"
  version                       = "11"
  storage_mb                    = var.db_storage
  public_network_access_enabled = true
  ssl_enforcement_enabled       = false

  administrator_login           = "psqladmin"
  administrator_login_password  = azurerm_key_vault_secret.lab-db-pwd.value

  tags = local.common_tags
}

resource "azurerm_postgresql_database" "lab" {
  name                = "aztf-labs-db"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_postgresql_server.lab.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "lab-rule1" {
  name                = "aztf-labs-fwrule-private"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_postgresql_server.lab.name
  start_ip_address    = cidrhost(azurerm_subnet.lab-private.address_prefixes[0],0)
  end_ip_address      = cidrhost(azurerm_subnet.lab-private.address_prefixes[0],255)
}

resource "azurerm_postgresql_firewall_rule" "lab-rule2" {
  name                = "aztf-labs-fwrule-bastion"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_postgresql_server.lab.name
  start_ip_address    = azurerm_linux_virtual_machine.lab-bastion.private_ip_address
  end_ip_address      = azurerm_linux_virtual_machine.lab-bastion.private_ip_address
}

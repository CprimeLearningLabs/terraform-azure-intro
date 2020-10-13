data "azurerm_key_vault_secret" "creds" {
  name         = "dbpassword"
  key_vault_id = azurerm_key_vault.lab.id
  depends_on   = [azurerm_key_vault_secret.lab-db-pwd]
}

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
  administrator_login_password  = data.azurerm_key_vault_secret.creds.value

  tags = local.common_tags
}

resource "azurerm_postgresql_database" "lab" {
  name                = "aztf-labs-db"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_postgresql_server.lab.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "lab" {
  for_each = local.db_fw_rules

  name                = "aztf-labs-fwrule-${each.key}"
  resource_group_name = azurerm_resource_group.lab.name
  server_name         = azurerm_postgresql_server.lab.name
  start_ip_address    = each.value.start_ip
  end_ip_address      = each.value.end_ip
}

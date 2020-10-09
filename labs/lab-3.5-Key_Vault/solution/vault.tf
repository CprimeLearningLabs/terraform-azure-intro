
data "azurerm_client_config" "current" {}

resource "random_password" "dbpassword" {
  length           = 16
  special          = true
  override_special = "_%#"
}

resource "azurerm_key_vault" "lab" {
  name                = "aztf-key-vault-${random_integer.suffix.result}"
  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "[GET VALUE FROM INSTRUCTOR]"
    secret_permissions = [
      "get",
      "set",
      "delete",
      "list"
    ]
  }

  tags = local.common_tags
}

resource "azurerm_key_vault_secret" "lab-db-pwd" {
  name         = "dbpassword"
  value        = random_password.dbpassword.result
  key_vault_id = azurerm_key_vault.lab.id
}

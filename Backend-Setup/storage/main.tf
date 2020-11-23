
resource "azurerm_resource_group" "backend-rg" {
  name     = "terraform-course-backend"
  location = var.location
}

resource "azurerm_storage_account" "backend-storage" {
  name                     = "aztfcoursebackend${var.sequence}"
  resource_group_name      = azurerm_resource_group.backend-rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend-container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.backend-storage.name
  container_access_type = "private"
}

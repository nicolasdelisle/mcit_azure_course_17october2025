resource "azurerm_storage_account" "azurestoagemcit" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rgoctobermcit.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "storagecontainermay" {
  name                  = var.storagecontainermay
  storage_account_id    = azurerm_storage_account.mcitstorage.id
  container_access_type = var.container_access_type
}

resource "azurerm_storage_blob" "storageblobmay" {
  name                   = var.storageblobmay
  storage_account_name   = azurerm_storage_account.mcitstorage.name
  storage_container_name = azurerm_storage_container.storagecontainermay.name
  type                   = var.blob_type
  source                 = var.blob_source
}

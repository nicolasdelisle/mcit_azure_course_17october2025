resource "azurerm_storage_account" "storageaccount" {
  name                     = "${var.name}${var.storage_account_name}"
  resource_group_name      = azurerm_resource_group.mcitrgnicolas.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "storageoctober" {
  name                  = var.storagecontainermay
  storage_account_id    = azurerm_storage_account.storageaccount.id
  container_access_type = var.container_access_type
}

resource "azurerm_storage_blob" "storageblobmay" {
  name                   = var.storageblobmay
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.storageoctober.name
  type                   = var.blob_type
  source                 = var.blob_source
}



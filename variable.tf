variable "subscription_id"{
  type=string
}
variable "client_id"{
  type=string
}
variable "client_secret"{
  type=string
}
variable "storage_account_name"{
  type=string
  default="mcitoctstorage"
}
variable "resource_group_name"{
  type=string
  default="azurerm_resource_group.rgoctobermcit.name"
}
variable "location"{
  type=string
  default="azurerm_resource_group.rgoctobermcit.location"
}
variable "account_tier"{
  type=string
  default="Standard"
}
variable "account_replication_type" {
  type=string
  default="GRS"
}
variable "environment"{
  type=string
  default="staging"
}

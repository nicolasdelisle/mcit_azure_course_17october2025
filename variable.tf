variable "subscription_id"{
  type=string
}
variable "client_id"{
  type=string
}
variable "client_secret"{
  type=string
}
variable "tenant_id"{
  type=string
}
variable "storage_account_name"{
  type=string
  default="mcitoctstorage"
}
variable "resource_group_name"{
  type=string
  default="mcitrgnicolas"
}
variable "location"{
  type=string
  default="canadacentral"
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
variable "environments_second" {
  default = ["dev", "qa", "stage", "prod"]
}
 
variable "service_names_town" {
  default = ["montreal", "toronto", "calgary", "ottawa"]
}
variable "firstname" {
  default = "Nicolas" 
}
variable "lastname" {
  default = "Delisle"
}
variable "env_string" {
  default = "dev,qa,stage,prod"
}

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
variable "countries" {
  default = ["Canada", "USA", "Mexico", "Brazil"]
}
 
variable "cities" {
  default = ["Vancouver", "NewYork", "Cancun", "Rio"]
}
 
variable "company" {
  default = "MCIT"
}
 
variable "department" {
  default = "CloudEngineering"
}
 
variable "skills_string" {
  default = "Terraform,Docker,Kubernetes,Python"
}
# -------------------
# Variables for lookup practice
# -------------------
variable "env_settings" {
  description = "Map of environment -> instance type"
  default = {
    dev   = "t2.micro"
    qa    = "t3.small"
    stage = "t3.medium"
    prod  = "m5.large"
  }
}
 
variable "city_codes" {
  description = "Map of city -> airport IATA code"
  default = {
    Vancouver = "YVR"
    Toronto   = "YYZ"
    Montreal  = "YUL"
    Calgary   = "YYC"
  }
}
 
variable "country_currency" {
  description = "Map of country -> currency code"
  default = {
    Canada = "CAD"
    USA    = "USD"
    Mexico = "MXN"
  }
}
 
variable "request_cities" {
  description = "Cities to resolve into airport codes for exercise 8"
  default     = ["Vancouver", "Calgary", "Ottawa"]
}
# A sentinel value used to detect missing keys via lookup() in exercise 9
locals {
  sentinel_missing = "__MISSING__"
}
# variable class 22 october
# local holding quotas for each plan
locals {
  plan_quotas = {
    free       = 100
    pro        = 1000
    enterprise = 10000
  }
}

variable "greeting" {
  description = "Map of greeting -> language"
  default = {
    Fr = "bonjours"
    En   = "hello"
    Es = "hola"
  }
}

variable "greetings" {
  description = "Map of greeting -> language"
  default = {
    stage = true
    qa   = true 
    dev = true
    prod = true
  }
}
# given variable to complete exercice

variable "user_plan" { 
  description = "Selected subscription plan" 
  default = "pro" 
}

variable "region" { 
  description = "Selected deployment region" 
  default     = "eu-west-1" 
}

locals {
  region_endpoints = {
    "us-east-1" = "api.use1.example.com"
    "eu-west-1" = "api.euw1.example.com"
  }

  override_endpoints = {
    "ap-south-1" = "api.aps1.example.com"
  }
}

locals {
  sentinel_missings = "MISSING"

  env_settings = {
    dev  = "t2.micro"
    qa   = "t3.small"
    prod = "m5.large"
  }
}

variable "lang" { 
  description = "Language code for greetings" 
  default = "fr" 
}

variable "requested_cities" { 
  description = "Cities to resolve to airport codes" 
  default = ["Toronto", "Ottawa", "Vancouver"] 
}

variable "country_input" { 
  description = "Country name for code lookup (case-insensitive demo)" 
  default = "usa" 
}

variable "service" { 
  description = "Service to fetch port for" 
  default = "api" 
}
locals {
  base_ports = {
    web = 80
    api = 8080
  }

  custom_ports = {
    api = 9000
  }
}

variable "feature_to_check" { 
  description = "Which feature flag to read" 
  default = "chat" 
}

variable "environments" { 
  description = "Environment to test presence in env_settings" 
  default = "stage" 
}

variable "product" {
  description = "Which product to price" 
  default = "widget" 
}


# class november 5

locals {
  base_name = lower(replace("${var.name_prefix}${var.name_suffix}", "/[^a-z0-9]/", ""))
  # Ensure global uniqueness if requested; SA name must be 3-24 chars, lowercase, unique
  composed_name = (var.generate_random_suffix
    ? lower(substr("${local.base_name}${random_string.sa_suffix.result}", 0, 24))
    : lower(substr(local.base_name, 0, 24))
  )
}
variable "name_prefix" {
  description = "Lowercase prefix for the storage account name (only a-z and 0-9)."
  type        = string
#no a default value
  default     = ""
  validation {
    condition     = can(regex("^[a-z0-9-]{3,60}$", var.name_prefix))
    error_message = "name_prefix must be 3-60 chars of lowercase letters, digits, or hyphens."
  }
}

variable "name_suffix" {
  description = "Optional suffix appended to the prefix BEFORE trimming to 24 chars. Lowercase/digits only recommended."
  type        = string
  default     = ""
}

variable "generate_random_suffix" {
  description = "Append a random alphanumeric suffix to help with global uniqueness."
  type        = bool
  default     = true
}

variable "random_suffix_length" {
  description = "Length of random suffix when generate_random_suffix is true."
  type        = number
  default     = 6
}

variable "account_kind" {
  description = "Storage account kind."
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["StorageV2","Storage","BlobStorage","FileStorage","BlockBlobStorage"], var.account_kind)
    error_message = "account_kind must be one of StorageV2, Storage, BlobStorage, FileStorage, BlockBlobStorage."
  }
}

variable "access_tier" {
  description = "Hot or Cool (only for StorageV2)."
  type        = string
  default     = "Hot"
  validation {
    condition     = contains(["Hot","Cool"], var.access_tier)
    error_message = "access_tier must be Hot or Cool."
  }
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version."
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = contains(["TLS1_0","TLS1_1","TLS1_2","TLS1_3"], var.min_tls_version)
    error_message = "min_tls_version must be TLS1_0, TLS1_1, TLS1_2, or TLS1_3."
  }
}

variable "allow_blob_public_access" {
  description = "Whether blob public access is allowed."
  type        = bool
  default     = false
}

variable "nfsv3_enabled" {
  description = "Enable NFSv3 (FileStorage only in supported regions)."
  type        = bool
  default     = false
}

variable "large_file_share_enabled" {
  description = "Enable large file shares."
  type        = bool
  default     = false
}

variable "cross_tenant_replication_enabled" {
  description = "Enable Cross-tenant replication."
  type        = bool
  default     = false
}

variable "hns_enabled" {
  description = "Enable hierarchical namespace (ADLS Gen2) – only with StorageV2."
  type        = bool
  default     = false
}

variable "blob_versioning_enabled" {
  description = "Enable blob versioning."
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "Managed identity type."
  type        = string
  default     = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned","UserAssigned","SystemAssigned, UserAssigned","None"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None."
  }
}

variable "network_rules" {
  description = <<EOT
Optional network rules:
{
  default_action             = "Deny" or "Allow"
  bypass                     = ["AzureServices","Logging","Metrics"]
  ip_rules                   = ["1.2.3.4","5.6.7.0/24"]
  virtual_network_subnet_ids = ["/subscriptions/.../subnets/..."]
}
EOT
  type = object({
    default_action             = string
    bypass                     = optional(list(string))
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = null
}

variable "containers" {
  description = <<EOT
List of containers to create:
[
  {
    name        = "raw"
    access_type = "private" # or "blob" / "container"
    metadata    = { env = "dev" }
  }
]
EOT
  type = list(object({
    name        = string
    access_type = string
    metadata    = optional(map(string))
  }))
  default = []
  validation {
    condition = alltrue([
      for c in var.containers : contains(["private","blob","container"], c.access_type)
    ])
    error_message = "Each container.access_type must be one of: private, blob, container."
  }
}

variable "lifecycle_rules" {
  description = <<EOT
Single-rule lifecycle config (expandable):
[
  {
    filters = {
      blob_types   = ["blockBlob"]
      prefix_match = ["logs/"]
      tag = {
        name  = "class"
        value = "cold"
      }
    }
    actions = {
      base_blob = {
        tier_to_cool_after_days           = 30
        tier_to_archive_after_days        = 90
        delete_after_days                 = 365
      }
      snapshot = {
        delete_after_days = 30
      }
      version = {
        delete_after_days = 60
      }
    }
  }
]
EOT
  type = list(object({
    filters = object({
      blob_types   = optional(list(string))
      prefix_match = optional(list(string))
      tag          = optional(object({ name = string, value = string }))
    })
    actions = object({
      base_blob = object({
        tier_to_cool_after_days    = optional(number)
        tier_to_archive_after_days = optional(number)
        delete_after_days          = optional(number)
      })
      snapshot = optional(object({
        delete_after_days = optional(number)
      }))
      version = optional(object({
        delete_after_days = optional(number)
      }))
    })
  }))
  default = []
}


# class november 3

// in terraform interger are called number
variable "frontend_http_port" {
  description = "Frontend port for the HTTP load balancer rule"
  type        = number
  default     = 80
}

variable "vm_names" {
  description = "List of VM names to create"
  default     = ["msuburb1", "msuburb2", "msuburb3", "msuburb4", "msuburb5"]
}
# class october 31

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "my-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "my-subnet"
}

variable "subnet_prefix" {
  description = "Subnet address prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_ip_name" {
  description = "Public IP name"
  type        = string
  default     = "my-public-ip"
}

variable "public_ip_allocation_method" {
  description = "Public IP allocation method"
  type        = string
  default     = "Dynamic"
}

variable "nic_name" {
  description = "Network Interface name"
  type        = string
  default     = "my-nic"
}

variable "ip_config_name" {
  description = "IP configuration name for NIC"
  type        = string
  default     = "internal"
}

variable "private_ip_allocation" {
  description = "Private IP allocation type"
  type        = string
  default     = "Dynamic"
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
  default     = "my-nsg"
}

variable "nsg_rule_name" {
  description = "NSG rule name"
  type        = string
  default     = "AllowSSH"
}

variable "nsg_rule_priority" {
  description = "NSG rule priority"
  type        = number
  default     = 1001
}

variable "nsg_rule_direction" {
  description = "Inbound or Outbound"
  type        = string
  default     = "Inbound"
}

variable "nsg_rule_access" {
  description = "Allow or Deny access"
  type        = string
  default     = "Allow"
}

variable "nsg_rule_protocol" {
  description = "Protocol (Tcp, Udp, *)"
  type        = string
  default     = "Tcp"
}

variable "nsg_rule_source_port" {
  description = "Source port range"
  type        = string
  default     = "*"
}

variable "nsg_rule_destination_port" {
  description = "Destination port range"
  type        = string
  default     = "22"
}

variable "nsg_rule_source_address" {
  description = "Source address prefix"
  type        = string
  default     = "*"
}

variable "nsg_rule_destination_address" {
  description = "Destination address prefix"
  type        = string
  default     = "*"
}

variable "vm_name" {
  description = "Virtual Machine name"
  type        = string
  default     = "myvm01"
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B2s"
}

variable "os_disk_caching" {
  description = "OS disk caching type"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_type" {
  description = "OS disk storage account type"
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "Image publisher"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "Image SKU"
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "Image version"
  type        = string
  default     = "latest"
}

variable "admin_username" {}
variable "admin_password" {}
# class 29_october
variable "second_resource_group_name" {
 description = "Name of the RG to create/use"
 type        = string
 default     = "rg_new"
}
variable "resource_group_location" {
 description = "Location for the RG (used if it doesn't exist)"
 type        = string
 default     = "canadacentral"
}
# Map of web apps to create. Keys must be unique IDs you choose.
# Each item: name, location, env, runtime, and optional app_settings map.
variable "webapps" {
  description = "Map of Linux Web Apps to deploy"
  type = map(object({
    name         = string
    location     = string
    env          = string
    runtime      = string
    app_settings = map(string)
  }))
  default = {
    app1 = {
      name         = "default-app"
      location     = "eastus"
      env          = "dev"
      runtime      = "PYTHON|3.11"
      app_settings = {}
    }
  }
}

# Example: pick SKU by environment with lookup(); defaults to P1v3 if env missing.
variable "sku_by_env" {
 description = "Map from env to App Service Plan SKU"
 type        = map(string)
 default = {
   dev  = "B1"
   qa   = "S1"
   prod = "P1v3"
 }
}
variable "tags" {
 description = "Common tags"
 type        = map(string)
 default     = {}
}

# class 27_october2 
#change name of variable in tf file to make a succesful plan 

# class 27_october
variable "rg_name" {
  type    = string
  default = "mcitnicolas"
}

variable "project" {
  type    = string
  default = "linux_project"
}

variable "common_app_settings" {
  type = map(string)
  default = {
    # Example environment variable for .NET apps
    "ASPNETCORE_ENVIRONMENT" = "Development"  

    # Logging level (generic, can be used in any app)
    "LOG_LEVEL" = "Information"  

    # Default for running from package (can be overridden in the app-specific map)
    "WEBSITE_RUN_FROM_PACKAGE" = "1"  

    # Any other shared settings, e.g., feature flags
    "FEATURE_X_ENABLED" = "false"
  }
  description = "Common application settings shared by all web apps (Linux & Windows)."
}

# F1 is the free tier one for linux also variable for linux 
variable "plan_sku_linux" {
  type    = string
  default = "F1"
}

variable "linux_node_version" {
  type    = string
  default = "20-lts"
}

variable "linux_app_name" {
  type    = string
  default = "my-linux-app"
}

variable "linux_app_settings" {
  type = map(string)
  default = {
    # Example: custom environment variables for Linux apps
    "CUSTOM_LINUX_SETTING" = "true"
    # You can add database connection strings, feature flags, or other Linux-specific configs
    # "DB_CONNECTION_STRING" = "Server=...;Database=...;User Id=...;Password=...;"
  }
  description = "Linux-specific application settings that override common settings for Linux Web Apps."
}

# windows variable
variable "plan_sku_windows" {
  type    = string
  default = "B1"
}

variable "windows_app_name" {
  type    = string
  default = "my-windows-app"
}
variable "windows_dotnet_version" {
  type        = string
  default     = "v6.0"
  description = "The .NET version for the Windows Web App (e.g., 'v6.0', 'v7.0')."
}

variable "windows_app_settings" {
  type = map(string)
  default = {
    # Example: custom environment variables for Windows apps
    "CUSTOM_WINDOWS_SETTING" = "true"
    # You can add database connection strings, feature flags, or other Windows-specific configs
    # "DB_CONNECTION_STRING" = "Server=...;Database=...;User Id=...;Password=...;"
  }
  description = "Windows-specific application settings that override common settings for Windows Web Apps."
}

# credential 4needed
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
# Ressource group storage var
variable "storage_account_name"{
  type=string
  default="test"
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
#container variable
variable "container_access_type"{
type=string
default="private"
}
variable "storagecontainermay"{
  type=string
  default="mcitsstoragecontmay"
}
variable "name"{
type = string
default = "nicolas"
}
# blob variable
variable "storageblobmay"{
  type=string
  default="mcitsstorageblobmay"
}
variable "blob_type"{
  type=string
  default="Block"
}
variable "blob_source"{
type=string
default="some-local-file.zip"
}
# exercice
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

variable "environments" { 
  description = "Environment to test presence in env_settings" 
  default = "stage" 
}

variable "product" {
  description = "Which product to price" 
  default = "widget" 
}

locals {
  country_codes_mixed = {
    Canada = "CA"
    USA    = "US"
    Mexico = "MX"
  }

  normalized_country_codes = {
    for k, v in local.country_codes_mixed : lower(k) => v
  }
}

locals {
  region  = "eu-west-1"
  product = "widget"

  regional_prices = {
    "eu-west-1" = {
      widget = 12.5
      pro    = 49.9
    }
    "us-east-1" = {
      widget = 10.0
    }
  }

  global_prices = {
    widget = 15.0
    pro    = 59.0
  }

  # Lookup logic:
  # 1 Check regional map for this region
  # 2 If not found, check global map
  # 3 If not found in either, return -1
  selected_price = lookup(
    lookup(local.regional_prices, local.region, {}),
    local.product,
    lookup(local.global_prices, local.product, -1)
  )
}

locals {
  feature_flags = {
    chat   = true
    search = false
  }
}

variable "feature_to_check" {
  description = "Which feature flag to read"
  default     = "chat"
}

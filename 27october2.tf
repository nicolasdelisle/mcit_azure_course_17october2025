/*
resource "azurerm_resource_group" "rg" {
  name     = "rg-webapps-foreach"
  location = "Canada Central"
}

# -----------------------------
# Create a service plan for Linux
# -----------------------------
resource "azurerm_service_plan" "linux_plan" {
  name                = "${var.linux_app_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.plan_sku_linux
}

# -----------------------------
# Create a Linux Web App
# -----------------------------
resource "azurerm_linux_web_app" "linux" {
  name                = var.linux_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.linux_plan.id

  site_config {
    application_stack {
      node_version   = var.linux_node_version
      python_version = null
      dotnet_version = null
    }
  }

  # Merge common app settings with Linux-specific overrides
  app_settings = merge(var.common_app_settings, var.linux_app_settings)
}

# -----------------------------
# Create a service plan for Windows
# -----------------------------
resource "azurerm_service_plan" "windows_plan" {
  name                = "${var.windows_app_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = var.plan_sku_windows
}

# -----------------------------
# Create a Windows Web App
# -----------------------------
resource "azurerm_windows_web_app" "windows" {
  name                = var.windows_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.windows_plan.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = var.windows_dotnet_version
      node_version   = null
    }
  }

  # Merge common app settings with Windows-specific overrides
  app_settings = merge(var.common_app_settings, var.windows_app_settings)
}

# -----------------------------
# Output app URLs
# -----------------------------
output "app_urls" {
  value = {
    linux_app   = azurerm_linux_web_app.linux.default_hostname
    windows_app = azurerm_windows_web_app.windows.default_hostname
  }
}
*/
/* codethat was given using variable of first exercice try again without changing the code 
resource "azurerm_resource_group" "rg" {
 name     = "rg-webapps-foreach"
 location = "Canada Central"
}
# Create a plan per app
resource "azurerm_service_plan" "plan" {
 for_each = var.apps
 name                = "${each.key}-plan"
 location            = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 os_type             = each.value.os_type
 sku_name            = each.value.sku_name
}
# Create a web app per app
resource "azurerm_linux_web_app" "linux" {
 for_each = {
   for name, cfg in var.apps : name => cfg if cfg.os_type == "Linux"
 }
 name                = "${each.key}-linux"
 location            = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 service_plan_id     = azurerm_service_plan.plan[each.key].id
 site_config {
   application_stack {
     node_version   = try(regex("^NODE\\|(.*)$", each.value.runtime_stack)[0], null)
     python_version = try(regex("^PYTHON\\|(.*)$", each.value.runtime_stack)[0], null)
     dotnet_version = try(regex("^DOTNET\\|(.*)$", each.value.runtime_stack)[0], null)
   }
 }
 app_settings = each.value.app_settings
}
resource "azurerm_windows_web_app" "windows" {
 for_each = {
   for name, cfg in var.apps : name => cfg if cfg.os_type == "Windows"
 }
 name                = "${each.key}-win"
 location            = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 service_plan_id     = azurerm_service_plan.plan[each.key].id
 site_config {
   application_stack {
     current_stack  = split("|", each.value.runtime_stack)[0]
     dotnet_version = try(regex("^DOTNET\\|(.*)$", each.value.runtime_stack)[0], null)
     node_version   = try(regex("^NODE\\|(.*)$", each.value.runtime_stack)[0], null)
   }
 }
 app_settings = each.value.app_settings
}
output "app_urls" {
 value = merge(
   { for k, v in azurerm_linux_web_app.linux   : k => v.default_hostname },
   { for k, v in azurerm_windows_web_app.windows: k => v.default_hostname }
 )
}
*/


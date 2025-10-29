
# Recreate service plans keyed by location-env (overrides earlier single-per-location approach)
# If you prefer ONE plan per location, comment this block and use the first asp.
resource "azurerm_service_plan" "asp_env" {
 for_each = local.plans
 name                = "asp-${replace(each.key, " ", "")}"
 resource_group_name = azurerm_resource_group.rg.name
 location            = each.value.location
 os_type  = "Linux"
 sku_name = each.value.sku # <--- comes from lookup(var.sku_by_env,...)
 tags     = var.tags
}
# Linux Web Apps – for_each over the webapps map
resource "azurerm_linux_web_app" "app" {
 for_each = var.webapps
 name                = each.value.name
 resource_group_name = azurerm_resource_group.rg.name
 location            = each.value.location
 # Bind to the plan matched by location-env
 service_plan_id = azurerm_service_plan.asp_env["${each.value.location}-${each.value.env}"].id
 https_only = true
 tags       = merge(var.tags, { env = each.value.env })
 site_config {
   linux_fx_version = each.value.runtime  # e.g., "PYTHON|3.11"
   ftps_state       = "Disabled"
 }
 # Demonstrating lookup() for an optional app setting with a default:
 # If FEATURE_FLAG not provided per app, default to "off".
 app_settings = merge(
   {
     "WEBSITE_RUN_FROM_PACKAGE" = "0"
     "FEATURE_FLAG"             = lookup(each.value.app_settings, "FEATURE_FLAG", "off") # <--- lookup()
   },
   each.value.app_settings
 )
 identity {
   type = "SystemAssigned"
 }
}
output "webapp_hostnames" {
 value = {
   for k, v in azurerm_linux_web_app.app : k => v.default_host_name
 }
}

locals {
  mcitconfig = [
    for f in fileset("${path.module}/configs", "[^_]*.yaml") :
    yamldecode(file("${path.module}/configs/${f}"))
  ]

  resource_groups = flatten([
    for c in local.mcitconfig : [
      for rg in try(c.resourcegroup, []) : {
        name     = rg.name
        location = rg.location
      }
    ]
  ])
############################
# Resource Groups
############################
resource "azurerm_resource_group" "rg" {
  for_each = { for rg in local.resource_groups : rg.name => rg }
  name     = each.value.name
  location = each.value.location
}

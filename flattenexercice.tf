locals {
  regions = ["us-east1", "us-west1"]
  zones   = ["a", "b"]
 
  region_zones = flatten([
    for region in local.regions : [
      for zone in local.zones : "${region}-${zone}"
    ]
  ])
}
 
output "region_zones" {
  value = local.region_zones
}
locals {
  nested_list = [
    ["apple", "banana"],
    ["grape", "orange"],
    ["mango"]
  ]
 
  flat_list = flatten(local.nested_list)
}
 
output "flat_list" {
  value = local.flat_list
}
locals {
  servers = {
    group1 = ["srv1", "srv2"]
    group2 = ["srv3"]
  }
 
  all_servers = flatten([
    for group, srv_list in local.servers : srv_list
  ])
}
 
output "all_servers" {
  value = local.all_servers
}

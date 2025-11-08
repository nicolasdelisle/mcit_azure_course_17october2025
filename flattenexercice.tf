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

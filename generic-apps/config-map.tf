locals {
  config_maps = [for x in var.apps: x if lookup(x, "config_map", null) != null]
}
resource "kubernetes_config_map" "config_map" {

  count = length(local.config_maps)

  metadata {
    name = element(local.config_maps.*.name, count.index)
    namespace = var.namespace
  }

  data = lookup(element(local.config_maps.*.config_map, count.index), "data", {})

  binary_data = lookup(element(local.config_maps.*.config_map, count.index), "binary_data", {})
}
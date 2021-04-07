locals {
  services = [for x in var.apps: x if lookup(x, "service_port", null) != null]
}
resource "kubernetes_service" "app_service" {

  count = length(local.services)

  metadata {
    name = element(local.services.*.name, count.index)
    namespace = var.namespace
  }
  spec {
    selector = {
      app = element(local.services.*.name, count.index)
    }
    # session_affinity = "ClientIP"
    port {
      port        = element(local.services.*.container_port, count.index)
      target_port = element(local.services.*.service_port, count.index)
    }

    type = lookup(element(local.services, count.index), "service_type", "ClusterIP")
  }
}
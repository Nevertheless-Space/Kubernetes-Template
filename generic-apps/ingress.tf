locals {
  ingresses = [for x in var.apps: x if lookup(x, "ingress", null) != null]
}
resource "kubernetes_ingress" "ingress" {

  count = length(local.ingresses)

  metadata {
    name = element(local.ingresses.*.name, count.index)
    namespace = var.namespace
    annotations = merge(
      {"kubernetes.io/ingress.class" = lookup(element(local.ingresses.*.ingress, count.index), "ingress_class", "nginx")},
      lookup(element(local.ingresses.*.ingress, count.index), "annotations", {})
    )
  }
  spec {
    dynamic "tls" {
      for_each = lookup(element(local.ingresses.*.ingress, count.index), "tls", null) == null ? [] : [1]
      content {
        hosts = lookup(element(local.ingresses.*.ingress.tls, count.index), "hosts", [])
        secret_name = lookup(element(local.ingresses.*.ingress.tls, count.index), "secret_name", "")
      }
    }
    rule {
      host = lookup(element(local.ingresses.*.ingress, count.index), "hostname", "")
      http {
        path {
          path = lookup(element(local.ingresses.*.ingress, count.index), "path", "/")
          backend {
            service_name = element(local.ingresses.*.name, count.index)
            service_port = element(local.ingresses.*.service_port, count.index)
          }
        }
      }
    }
  }
}
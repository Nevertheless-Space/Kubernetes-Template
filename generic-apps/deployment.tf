resource "kubernetes_deployment" "deployment" {

  count = length(var.apps)

  metadata {
    name = element(var.apps.*.name, count.index)
    namespace = var.namespace
    labels = lookup(element(var.apps, count.index), "labels", {})
  }

  spec {
    replicas = lookup(element(var.apps, count.index), "replicas", 1)

    selector {
      match_labels = {
        app = element(var.apps.*.name, count.index)
      }
    }

    template {
      metadata {
        labels = merge(
          {app = element(var.apps.*.name, count.index)},
          lookup(element(var.apps, count.index), "labels", {})
        )
      }

      spec {
        container {
          image = element(var.apps.*.image, count.index)
          name  = element(var.apps.*.name, count.index)

          dynamic "port" {
            for_each = lookup(element(var.apps, count.index), "container_port", null) == null ? [] : [1]
            content {
              container_port = element(var.apps.*.container_port, count.index)
            }
          }

          dynamic "resources" {
            for_each = lookup(element(var.apps, count.index), "resources", null) == null ? [] : [1]
            content {
              limits = lookup(element(var.apps, count.index), "limits", {})
              requests = lookup(element(var.apps, count.index), "requests", {})
            }
          }

          # liveness_probe {
          #   http_get {
          #     path = "/nginx_status"
          #     port = 80

          #     http_header {
          #       name  = "X-Custom-Header"
          #       value = "Awesome"
          #     }
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}
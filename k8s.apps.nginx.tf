locals {
  k8s_apps_nginx_enabled = true
  k8s_apps_nginx_depends_on = module.aks.kube_config

  k8s_apps_nginx_namespace = "nginx"

  k8s_apps_nginx_specs = [{
    name = "nginx"
    image = "nginx"
    replicas = 1
    labels = {}
    limits = {}
    requests = {}
  }]
}
resource "kubernetes_namespace" "nginx" {

  provider = kubernetes.default
  depends_on = [local.k8s_apps_nginx_depends_on]
  count = local.k8s_apps_nginx_enabled == true ? 1 : 0

  metadata {
    name = local.k8s_apps_nginx_namespace
    labels = {
      name = local.k8s_apps_nginx_namespace
    }
  }
}
resource "kubernetes_deployment" "app_deployment" {

  provider = kubernetes.default
  depends_on = [kubernetes_namespace.nginx]
  count = local.k8s_apps_nginx_enabled == true ? length(local.k8s_apps_nginx_specs) : 0

  metadata {
    name = element(local.k8s_apps_nginx_specs.*.name, count.index)
    namespace = local.k8s_apps_nginx_namespace
    labels = lookup(element(local.k8s_apps_nginx_specs, count.index), "labels", {})
  }

  spec {
    replicas = element(local.k8s_apps_nginx_specs.*.replicas, count.index)

    selector {
      match_labels = {
        app = element(local.k8s_apps_nginx_specs.*.name, count.index)
      }
    }

    template {
      metadata {
        labels = merge(
          {app = element(local.k8s_apps_nginx_specs.*.name, count.index)},
          lookup(element(local.k8s_apps_nginx_specs, count.index), "labels", {})
        )
      }

      spec {
        container {
          image = element(local.k8s_apps_nginx_specs.*.image, count.index)
          name  = element(local.k8s_apps_nginx_specs.*.name, count.index)

          resources {
            limits = lookup(element(local.k8s_apps_nginx_specs, count.index), "limits", {})
            requests = lookup(element(local.k8s_apps_nginx_specs, count.index), "requests", {})
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
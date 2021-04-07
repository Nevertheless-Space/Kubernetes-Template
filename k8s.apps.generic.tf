locals {
  k8s_apps_generic_enabled = true
  k8s_apps_generic_depends_on = module.aks.kube_config

  k8s_apps_generic_namespace = "apps"

  k8s_apps_generic_specs = [{
    # replicas = 1
    name = "nginx"
    image = "nginx"
    container_port = 80
    service_port = 80
    # service_type = "ClusterIP"
    # labels = {}
    # resources = {
    #   limits = {
    #     cpu    = "0.5"
    #     memory = "512Mi"
    #   }
    #   requests = {
    #     cpu    = "250m"
    #     memory = "50Mi"
    #   }
    # }
    config_map = {
      mount_path = "/usr/share/nginx/html"
      data = {
        "index.html" = "${file("./assets/nginx-01/index.html")}"
      }
      # binary_data = {}
    }
    ingress = {
      ingress_class = "nginx-test"
      # hostname = ""
      # path = "/"
      # annotations = {}
      # tls = {
      #   hosts = []
      #   secret_name = "test-cert"
      # }
    }
  }]
}
resource "kubernetes_namespace" "apps" {

  provider = kubernetes.default
  depends_on = [local.k8s_apps_generic_depends_on]
  count = local.k8s_apps_generic_enabled == true ? 1 : 0

  metadata {
    name = local.k8s_apps_generic_namespace
    labels = {
      name = local.k8s_apps_generic_namespace
    }
  }
}
module "generic-apps" {

  providers = {
    kubernetes = kubernetes.default
  }
  
  depends_on = [kubernetes_namespace.apps]
  count = local.k8s_apps_generic_enabled == true ? 1 : 0

  source = "./generic-apps"
  
  namespace = local.k8s_apps_generic_namespace
  apps = local.k8s_apps_generic_specs
}
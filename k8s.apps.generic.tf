locals {
  k8s_apps_generic_enabled = true
  k8s_apps_generic_depends_on = module.aks.kube_config

  k8s_apps_generic_namespace = "apps"

  k8s_apps_generic_specs = [{
    name = "nginx-01"
    image = "nginx"
    container_port = 80
    service_port = 80
    config_map = {
      mount_path = "/usr/share/nginx/html"
      data = {
        "index.html" = file("./assets/nginx-01/index.html")
      }
    }
    # ingress = {
    #   ingress_class = "nginx-test"
    # }
  },
  {
    name = "nginx-02"
    image = "nginx"
    container_port = 80
    service_port = 80
    config_map = {
      mount_path = "/usr/share/nginx/html"
      data = {
        "index.html" = file("./assets/nginx-02/index.html")
      }
    }
    ingress = {
      ingress_class = "nginx-test"
    }
  },
  {
    name = "debug"
    image = "registry.gitlab.com/nevertheless.space/docker-registry/linux-shell"
    container_port = null
  }
  ]
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

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/apps/generic?ref=kubernetes/apps/generic-debug"
  
  namespace = local.k8s_apps_generic_namespace
  apps = local.k8s_apps_generic_specs
}
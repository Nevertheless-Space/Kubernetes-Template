locals {
  k8s_core_dns_enabled = true
  k8s_core_dns_depends_on = module.aks.kube_config

  k8s_core_dns_namespace = "apps"

  k8s_core_dns_specs = [{
    name = "test"
    ips = ["192.168.200.123"]
  }]
}
resource "kubernetes_service" "test" {

  provider = kubernetes.default
  depends_on = [local.k8s_core_dns_depends_on]
  count = local.k8s_core_dns_enabled == true ? 1 : 0

  metadata {
    name = element(local.k8s_core_dns_specs.*.name, count.index)
    namespace = local.k8s_core_dns_namespace
  }
  spec {
    cluster_ip = "None"
    type = "ClusterIP"
    external_ips = element(local.k8s_core_dns_specs.*.ips, count.index)
  }
}

# resource "kubernetes_config_map" "config_map" {

  # provider = kubernetes.default
  # depends_on = [local.k8s_core_dns_depends_on]
  # count = local.k8s_core_dns_enabled == true ? 1 : 0

#   metadata {
#     name = "coredns-custom"
#     namespace = "kube-system"
#     labels = {
#       "addonmanager.kubernetes.io/mode" = "EnsureExists"
#       k8s-app = "kube-dns"
#       "kubernetes.io/cluster-service" = true
#     }
#   }
#   data = {
#     "external_endpoints.override" = "k8s_external example.org"
#   }
# }
# # nslookup test.apps.example.org


resource "helm_release" "ingresscontroller_nginx" {

  provider = helm.default
  depends_on = [local.k8s_core_dns_depends_on]
  count = local.k8s_core_dns_enabled == true ? 1 : 0

  name       = element(local.k8s_core_dns_specs.*.name, count.index)
  repository = "https://coredns.github.io/helm"
  chart      = "coredns"
  version    = "1.15.0"
  namespace  = local.k8s_core_dns_namespace
  timeout    = 900

  # set {
  #   name  = "controller.replicaCount"
  #   value = lookup(element(var.ingress_controllers, count.index), "replicas", local.defaults.replicas)
  # }
  # set {
  #   name  = "controller.ingressClass"
  #   value = lookup(element(var.ingress_controllers, count.index), "ingress_class", local.defaults.ingress_class)
  # }
  # set {
  #   name  = "controller.service.enableHttp"
  #   value = lookup(element(var.ingress_controllers, count.index), "enable_http", local.defaults.enable_http)
  # }
  # set {
  #   name  = "controller.service.enableHttps"
  #   value = lookup(element(var.ingress_controllers, count.index), "enable_https", local.defaults.enable_https)
  # }
  # set {
  #   name  = "controller.config.log-format-upstream"
  #   value = lookup(element(var.ingress_controllers, count.index), "log_format", local.defaults.log_format)
  # }

  # # ---------------------------------- Default Cert ---------------------------------- #
  # dynamic "set" {
  #   for_each = lookup(element(var.ingress_controllers, count.index), "default_cert", null) == null ? [] : [1]
  #   content {
  #     name  = "controller.extraArgs.default-ssl-certificate"
  #     value = element(var.ingress_controllers.*.default_cert, count.index)
  #   }
  # }
  # # ------------------------------ Other Configurations ------------------------------ #
  # dynamic "set" {
  #   for_each = lookup(element(var.ingress_controllers, count.index), "other_configurations", null) == null ? [] : element(var.ingress_controllers.*.other_configurations, count.index)
  #   content {
  #     name  = set.value.name
  #     value = set.value.value
  #   }
  # }
  # # ---------------------------------- Annotations ----------------------------------- #
  # dynamic "set" {
  #   for_each = lookup(element(var.ingress_controllers, count.index), "annotations", null) == null ? [] : element(var.ingress_controllers.*.annotations, count.index)
  #   content {
  #     name  = "controller.service.annotations.${replace(set.value.name, ".", "\\.")}"
  #     value = set.value.value
  #   }
  # }
}
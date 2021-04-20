locals {
  k8s_istio_enabled = true
  k8s_istio_depends_on = module.aks.kube_config

  helm_timeout = 900

  k8s_istio_namespace = "istio-system"

  k8s_istio_specs = {
    name = "istio"
  }
}
# resource "kubernetes_namespace" "istio_system" {

#   provider = kubernetes.default
#   depends_on = [local.k8s_istio_depends_on]

#   metadata {
#     name = "istio-system"
#   }
# }


resource "helm_release" "istio_base" {

  # depends_on = [kubernetes_namespace.istio_system]
  provider = helm.default

  name       = "${local.k8s_istio_specs.name}-base"
  # repository = "https://kubernetes.github.io/ingress-nginx"
  # chart      = "manifests/charts/base"

  chart      = "./istio/manifests/base"
  
  namespace  = "istio-system"
  timeout    = local.helm_timeout

  create_namespace = true

}

resource "helm_release" "istio_discovery" {

  depends_on = [helm_release.istio_base]
  provider = helm.default

  name       = "${local.k8s_istio_specs.name}-discovery"
  # repository = "https://kubernetes.github.io/ingress-nginx"
  # chart      = "manifests/charts/base"

  chart      = "./istio/manifests/istio-control/istio-discovery"
  
  namespace  = "istio-system"
  timeout    = local.helm_timeout

  # create_namespace = true

  values = [file("./istio/manifests/global.yaml")]

}
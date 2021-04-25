locals {
  k8s_istio_enabled = true
  k8s_istio_depends_on = module.aks.kube_config

  k8s_istio_specs = {
    test = "example"
  }
}
module "istio" {

  providers = {
    helm = helm.default
    kubernetes = kubernetes.default
  }
  
  depends_on = [local.k8s_istio_depends_on]
  count = local.k8s_istio_enabled == true ? 1 : 0

  source = "./istio-module"

  specs = local.k8s_istio_specs
}
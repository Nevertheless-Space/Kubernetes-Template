locals {
  k8s_boundary_enabled = true
  k8s_boundary_depends_on = module.aks.kube_config

  k8s_boundary_namespace = "boundary"
  k8s_boundary_specs = {
    name = "boundary-test"
    postgresql = {
      username = "postgres"
      password = "postgres_password"
      storage_class = "default"
    }
  }
}
resource "kubernetes_namespace" "boundary" {
  
  provider = kubernetes.default
  depends_on = [local.k8s_boundary_depends_on]
  count = local.k8s_boundary_enabled == true ? 1 : 0
  
  metadata {
    name = local.k8s_boundary_namespace
  }
}
module "boundary" {

  providers = {
    helm = helm.default
    kubernetes = kubernetes.default
  }
  
  depends_on = [kubernetes_namespace.boundary]
  count = local.k8s_boundary_enabled == true ? 1 : 0

  source = "./boundary-module"

  namespace = local.k8s_boundary_namespace
  specs = local.k8s_boundary_specs
}
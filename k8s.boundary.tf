locals {
  k8s_boundary_enabled = true
  k8s_boundary_depends_on = module.aks.kube_config

  k8s_boundary_namespace = "boundary"
  k8s_boundary_specs = {
    name = "boundary-test"
    version = "0.1.8"
    
    postgresql_username = "postgres"
    postgresql_password = "postgres_password"
    postgresql_storage_class = "default"
    
    init_default_mode = false
    init_config_file = file("assets/boundary/config.hcl")
    # init_kms_recovery = file("assets/boundary/kms_recovery.hcl")
    
    ingress_class = "nginx-test"
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
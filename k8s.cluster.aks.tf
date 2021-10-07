# ----------------------- Variables -----------------------
variable "k8s_cluster_aks_location" { default = "North Europe" }
variable "k8s_cluster_aks_nodes_sku" { default = "Standard_D2_v2" }
variable "k8s_cluster_aks_nodes_count" { default = 3}
variable "k8s_cluster_aks_version" { default = "1.20.9" }
variable "k8s_cluster_aks_nodes_os_disk_size" { default = 30}
# ----------------------- Variables -----------------------
locals {
  k8s_cluster_aks_service_principal_client_id = var.account_azure_client_id
  k8s_cluster_aks_service_principal_client_secret = var.account_azure_client_secret
}
module "aks" {
  source = "git::https://github.com/nevertheless-space/terraform-modules//azure/aks?ref=azure/aks-1.0.0"
  
  tenant = var.tenant
  env = var.env
  location = var.k8s_cluster_aks_location
  tags = {
    Tenant = var.tenant
    Environment = var.env
  }
  service_principal_client_id = local.k8s_cluster_aks_service_principal_client_id
  service_principal_client_secret = local.k8s_cluster_aks_service_principal_client_secret
  nodes_sku = var.k8s_cluster_aks_nodes_sku
  nodes_count = var.k8s_cluster_aks_nodes_count
  k8s_version = var.k8s_cluster_aks_version
  nodes_os_disk_size = var.k8s_cluster_aks_nodes_os_disk_size
}
provider "kubernetes" {

  alias = "default"

  host                   = module.aks.kube_config.0.host
  client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
  client_key             = base64decode(module.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
}
provider "helm" {
  
  debug = true
  alias = "default"

  kubernetes {
    host                   = module.aks.kube_config.0.host
    client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
    client_key             = base64decode(module.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
  }
}
output "kube_config_raw" {
  value = nonsensitive(module.aks.kube_config_raw)
}
# ----------------------- Variables -----------------------
variable "aks_location" { default = "North Europe" }
variable "aks_nodes_sku" { default = "Standard_D2_v2" }
variable "aks_nodes_count" { default = 3}
variable "aks_version" { default = "1.18.14" }
variable "aks_nodes_os_disk_size" { default = 30}
# ----------------------- Variables -----------------------
module "aks" {
  source = "git::https://github.com/nevertheless-space/terraform-modules//azure/aks?ref=azure/aks-1.0.0"
  
  tenant = var.tenant
  env = var.env
  location = var.aks_location
  tags = {
    Tenant = var.tenant
    Environment = var.env
  }
  service_principal_client_id = var.client_id
  service_principal_client_secret = var.client_secret
  nodes_sku = var.aks_nodes_sku
  nodes_count = var.aks_nodes_count
  k8s_version = var.aks_version
  nodes_os_disk_size = var.aks_nodes_os_disk_size
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
  value = module.aks.kube_config_raw
}
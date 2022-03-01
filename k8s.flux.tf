# ----------------------- Variables -----------------------
variable "k8s_flux_enabled" { default = false }
variable "k8s_flux_version" { default = "v0.24.0" }
variable "k8s_flux_target_path" { default = "" }
variable "k8s_flux_main_repo_url" { default = "" }
variable "k8s_flux_main_repo_branch" { default = "main" }
variable "k8s_flux_main_repo_username" { default = "flux" }
variable "k8s_flux_main_repo_token" { default = "" }
# ----------------------- Variables -----------------------
resource "kubernetes_namespace" "flux_system" {
  provider = kubernetes.default
  count = var.k8s_flux_enabled ? 1 : 0

  metadata {
    name = "flux-system"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}
data "flux_install" "main" {
  count = var.k8s_flux_enabled ? 1 : 0

  target_path = var.k8s_flux_target_path
  network_policy = false
  version = var.k8s_flux_version
}
data "kubectl_file_documents" "flux_apply" {
  count = var.k8s_flux_enabled ? 1 : 0

  content = data.flux_install.main.0.content
}
locals {
  k8s_flux_apply = var.k8s_flux_enabled ? [ for v in data.kubectl_file_documents.flux_apply.0.documents : {
      data: yamldecode(v)
      content: v
    }
  ] : []
}
resource "kubectl_manifest" "flux_apply" {
  provider = kubectl.default

  for_each   = { for v in local.k8s_flux_apply : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = each.value
}
data "flux_sync" "main" {
  count = var.k8s_flux_enabled ? 1 : 0

  target_path = var.k8s_flux_target_path
  url = var.k8s_flux_main_repo_url
  branch = var.k8s_flux_main_repo_branch
}
data "kubectl_file_documents" "flux_sync" {
  count = var.k8s_flux_enabled ? 1 : 0

  content = data.flux_sync.main.0.content
}
locals {
  k8s_flux_sync = var.k8s_flux_enabled ? [ for v in data.kubectl_file_documents.flux_sync.0.documents : {
      data: yamldecode(v)
      content: v
    }
  ] : []
}
resource "kubectl_manifest" "flux_sync" {
  provider = kubectl.default

  for_each   = { for v in local.k8s_flux_sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = each.value
}
resource "kubernetes_secret" "flux_main" {
  provider = kubernetes.default
  count = var.k8s_flux_enabled ? 1 : 0
  depends_on = [kubectl_manifest.flux_apply]

  metadata {
    name      = data.flux_sync.main.0.secret
    namespace = data.flux_sync.main.0.namespace
  }
  data = {
    username = var.k8s_flux_main_repo_username
    password = var.k8s_flux_main_repo_token
  }
}
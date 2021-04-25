locals {
  istio_repo_folder = "${path.root}/istio-repo"
  templates_folder = "${local.istio_repo_folder}/manifests/charts"
}
resource "null_resource" "istio_repo_clone" {

  provisioner "local-exec" {
    command = "git clone -b ${var.istio_version} https://github.com/istio/istio.git ${local.istio_repo_folder}"
  }
}
resource "kubernetes_namespace" "istio" {

  depends_on = [null_resource.istio_repo_clone]

  metadata {
    name = var.namespace
  }
}
resource "helm_release" "istio_base" {

  depends_on = [kubernetes_namespace.istio]

  name       = "istio-base"
  chart      = "${local.templates_folder}/base"
  
  namespace  = var.namespace
  timeout    = var.helm_timeout
}
resource "helm_release" "istio_discovery" {

  depends_on = [helm_release.istio_base]

  name       = "istio-discovery"
  chart      = "${local.templates_folder}/istio-control/istio-discovery"
  
  namespace  = var.namespace
  timeout    = var.helm_timeout
}
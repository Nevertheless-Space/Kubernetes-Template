# ----------------------- Variables -----------------------
variable "k8s_apps_nginx-controller_enabled" { default = false }
variable "k8s_apps_nginx-controller_chart-version" { default = "3.15.2" }
# ----------------------- Variables -----------------------
locals{
  k8s_apps_nginx_controller_depends_on = module.aks.kube_config

  k8s_apps_nginx_controller_namespace = "nginx-controllers"
  k8s_apps_nginx_controller_specs = [
    {
      name = "default"
      ingress_class = "nginx"
      replicas = 1
      enable_http = true
      enable_https = true
      log_format = "time_local=$time_local client=$remote_addr host=$host method=$request_method request=$request request_length=$request_length status=$status bytes_sent=$bytes_sent body_bytes_sent=$body_bytes_sent referer=$http_referer user_agent=$http_user_agent upstream_addr=$upstream_addr upstream_status=$upstream_status request_time=$request_time upstream_response_time=$upstream_response_time upstream_connect_time=$upstream_connect_time upstream_header_time=$upstream_header_time"
      other_configurations = [
  	    {
          name = "controller.config.proxy-buffer-size"
          value = "16k"
        },
        {
          name = "controller.config.proxy-buffers-number"
          value = "4"
        },
        {
          name = "controller.config.use-forwarded-headers"
          value = "true"
        },
      ]
    },
  ]
}
resource "kubernetes_namespace" "ingress_controller" {

  provider = kubernetes.default
  depends_on = [local.k8s_apps_nginx_controller_depends_on]
  count = var.k8s_apps_nginx-controller_enabled ? 1 : 0

  metadata {
    name = local.k8s_apps_nginx_controller_namespace
    labels = {
      name = local.k8s_apps_nginx_controller_namespace
    }
  }
}
module "ingress_controller" {

  providers = {
    helm = helm.default
  }
  
  depends_on = [kubernetes_namespace.ingress_controller]
  count = var.k8s_apps_nginx-controller_enabled ? 1 : 0

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/ingress/nginx-controller?ref=kubernetes/ingress/nginx-controller-1.1.0"
  
  namespace = local.k8s_apps_nginx_controller_namespace
  chart_version = var.k8s_apps_nginx-controller_chart-version
  ingress_controllers = local.k8s_apps_nginx_controller_specs
}
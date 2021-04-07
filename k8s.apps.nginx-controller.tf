locals{
  k8s_apps_nginx_controller_enabled = true
  k8s_apps_nginx_controller_depends_on = module.aks.kube_config

  k8s_apps_nginx_controller_namespace = "nginx-controllers"
  k8s_apps_nginx_controller_version = "2.11.3"

  k8s_apps_nginx_controller_specs = [
    {
      name = "test"
      ingress_class = "nginx-test"
      enable_http = true
      enable_https = true
      log_format = "[$time_local] $remote_addr - $remote_user \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\" \"$host\" \"$http_x_forwarded_host\" \"$http_x_forwarded_proto\""
      other_configurations = [
        {
          name = "controller.config.proxy-buffer-size"
          value = "16k"
        },
        {
          name = "controller.config.proxy-buffers"
          value = "4 16k"
        },
        {
          name = "proxy-busy-buffers-size"
          value = "16k"
        },
        {
          name = "use-forwarded-headers"
          value = "true"
        }
      ]
      annotations = [
        {
          name = "test.annotation"
          value = "example"
        }
      ]
    },
  ]
}
resource "kubernetes_namespace" "ingress_controller" {

  provider = kubernetes.default
  depends_on = [local.k8s_apps_nginx_controller_depends_on]
  count = local.k8s_apps_nginx_controller_enabled == true ? 1 : 0

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
  count = local.k8s_apps_nginx_controller_enabled == true ? 1 : 0

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/ingress/nginx-controller?ref=kubernetes/ingress/nginx-controller-1.0.0"
  
  namespace = local.k8s_apps_nginx_controller_namespace
  chart_version = local.k8s_apps_nginx_controller_version
  ingress_controllers = local.k8s_apps_nginx_controller_specs
}
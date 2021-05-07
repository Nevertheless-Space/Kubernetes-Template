locals {
  boundary_version = "0.1.8"
  k8s_apps_generic_specs = [{
      name = lookup(var.specs, "name", "boundary")
      image = "hashicorp/boundary:${local.boundary_version}"
      env_variables = [
        {
          name = "BOUNDARY_POSTGRES_URL"
          value = local.postgresql_connection_string
        }
      ]
      container_ports = [
        {
          port = "9200"
        },
        {
          port = "9201"
        },
        {
          port = "9202"
        }
      ]
      service_ports = [
        {
          port = "9200"
        },
        {
          port = "9201"
        },
        {
          port = "9202"
        }
      ]
      ingress = {
        ingress_class = "nginx-test"
      }
      # config_map = {
      #   mount_path = "/boundary"
      #   data = {
      #     "config.hcl" = file("${path.module}/boundary.config.hcl")
      #   }
      # }
    },  
  ]
}
module "generic-apps" {

  depends_on = [kubernetes_job.boundary_init]

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/apps/generic?ref=kubernetes/apps/generic-debug"
  
  namespace = var.namespace
  apps = local.k8s_apps_generic_specs
}
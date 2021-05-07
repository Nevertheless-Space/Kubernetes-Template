locals {
  k8s_apps_generic_specs = [{
      name = lookup(var.specs, "name", "boundary")
      image = "hashicorp/boundary"
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
    },  
  ]
}
module "generic-apps" {

  depends_on = [kubernetes_job.postgresql_init]

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/apps/generic?ref=kubernetes/apps/generic-debug"
  
  namespace = var.namespace
  apps = local.k8s_apps_generic_specs
}
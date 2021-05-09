locals {
  apps_generic_specs = [{
      name = lookup(var.specs, "name", local.defaults.boundary_name)
      image = "hashicorp/boundary:${lookup(var.specs, "version", local.defaults.boundary_version)}"
      env_variables = [{
          name = "BOUNDARY_POSTGRES_URL"
          value = local.postgresql_connection_string
        }
      ]
      container_ports = [{port = "9200"},{port = "9201"},{port = "9202"}]
      service_ports = [{port = "9200"},{port = "9201"},{port = "9202"}]
      service_type = lookup(var.specs, "service_type", local.defaults.boundary_service_type)
      ingress = {
        ingress_class = lookup(var.specs, "ingress_class", local.defaults.boundary_ingress_class)
      }
      config_map = lookup(var.specs, "init_default_mode", local.defaults.boundary_init_default_mode) ? null : {
        mount_path = "/boundary"
        data = {
          "config.hcl" = var.specs.init_config_file
        }
      }
    },  
  ]
}
module "generic-apps" {

  depends_on = [module.init-job]

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/apps/generic?ref=kubernetes/apps/generic-0.2.0"
  
  namespace = var.namespace
  apps = local.apps_generic_specs
}
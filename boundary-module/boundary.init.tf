locals {
  boundary_init_command = lookup(var.specs, "init_default_mode", local.defaults.boundary_init_default_mode) ? local.boundary_init_command_default : local.boundary_init_command_custom
  boundary_init_command_default = "boundary database init -config /boundary/config.hcl"
  boundary_init_command_custom = "boundary database init -skip-initial-login-role-creation -config /boundary/config.hcl"
}
module "init-job" {

  depends_on = [module.postgresql]
  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/jobs/generic?ref=kubernetes/jobs/generic-0.1.0"
  
  namespace = var.namespace
  jobs = [{
    name = "${lookup(var.specs, "name", local.defaults.boundary_name)}-init" 
    image = "hashicorp/boundary:${lookup(var.specs, "version", local.defaults.boundary_version)}"
    command = split(" ", local.boundary_init_command)
    env_variables = [{
      name = "BOUNDARY_POSTGRES_URL"
      value = local.postgresql_connection_string
    }]
    config_map = lookup(var.specs, "init_config_file", null) == null ? null : {
      mount_path = "/boundary"
      data = {
        "config.hcl" = var.specs.init_config_file
      }
    }
    wait_for_completion = true
    completion_timeout = 60
  }]
}
locals {
  boundary_init_command = lookup(var.specs, "init_default_mode", local.defaults.boundary_init_default_mode) ? "boundary database init -config /boundary/config.hcl" : "boundary database init -skip-initial-login-role-creation -config /boundary/boundary.hcl"
}
resource "kubernetes_job" "boundary_init" {

  depends_on = [module.postgresql, kubernetes_config_map.boundary_init]
  
  metadata {
    name = "${lookup(var.specs, "name", local.defaults.boundary_name)}-init"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "boundary-init"
          image   = "hashicorp/boundary:${lookup(var.specs, "version", local.defaults.boundary_version)}"
          command = split(" ", local.boundary_init_command)
          env {
            name = "BOUNDARY_POSTGRES_URL"
            value = local.postgresql_connection_string
          }
          dynamic "volume_mount" {
            for_each = lookup(var.specs, "init_default_mode", local.defaults.boundary_init_default_mode) ? [] : [1]
            content {
              name = "config-hcl"
              mount_path = "/boundary"
            }
          }
        }
        dynamic "volume" {
          for_each = lookup(var.specs, "init_default_mode", local.defaults.boundary_init_default_mode) ? [] : [1]
          content {
            name = "config-hcl"
            config_map {
              name = "${lookup(var.specs, "name", local.defaults.boundary_name)}-init"
            }
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = true
}
resource "kubernetes_config_map" "boundary_init" {

  count = lookup(var.specs, "init_default_mode", local.defaults.boundary_init_default_mode) ? 0 : 1

  metadata {
    name = "${lookup(var.specs, "name", local.defaults.boundary_name)}-init"
    namespace = var.namespace
  }

  data = {
    "boundary.hcl" = var.specs.init_config_file
  }
}
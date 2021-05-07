locals {
  boundary_init_command = "boundary database init -config /boundary/config.hcl"
  # boundary_init_command = "boundary database init -skip-initial-login-role-creation -config /boundary/boundary.hcl"
}
resource "kubernetes_job" "boundary_init" {

  depends_on = [module.postgresql, kubernetes_config_map.boundary_init]
  
  metadata {
    name = "boundary-init"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "boundary-init"
          image   = "hashicorp/boundary:${local.boundary_version}"
          command = split(" ", local.boundary_init_command)
          env {
            name = "BOUNDARY_POSTGRES_URL"
            value = local.postgresql_connection_string
          }
          volume_mount {
            name = "config-hcl"
            mount_path = "/boundary"
          }
        }
        volume {
          name = "config-hcl"
          config_map {
            name = "boundary-init"
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
  metadata {
    name = "boundary-init"
    namespace = var.namespace
  }

  data = {
    "boundary.hcl" = file("${path.module}/boundary.config.hcl")
  }
}
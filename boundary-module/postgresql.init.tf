locals {
  postgresql_init_command = "boundary database init -config /boundary/config.hcl"
}
resource "kubernetes_job" "postgresql_init" {

  depends_on = [module.postgresql]
  
  metadata {
    name = "postgresql-init"
    namespace = var.namespace
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "postgresql-init"
          image   = "hashicorp/boundary"
          command = split(" ", local.postgresql_init_command)
          env {
            name = "BOUNDARY_POSTGRES_URL"
            value = local.postgresql_connection_string
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = true
}